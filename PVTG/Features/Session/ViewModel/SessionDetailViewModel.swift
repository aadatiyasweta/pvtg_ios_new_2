//
//  SessionDetailViewModel.swift
//  PVTG
//
//  Created by Test Machine on 13/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit
import Alamofire
import Stripe

protocol GetResponse: AnyObject{
    func reloadData()
    func bookingSuccess()
    func allTicketsSold()
    func reloadTime()
    func sessionTimeDetail()
    func refundAPiResponse()
}
protocol GetBookingResponse: AnyObject{
    func bookingSuccess()
    func getPrefrenceId(id : String)
    
    
}
class SessionDetailViewModel: BaseVm {
    
    //MARK: - Properties
    var model: SessionDetailResult?
    weak var delegate: GetResponse?
    weak var bookingDelegate: GetBookingResponse?
    var timeArr: AllTimeBase?
    var availableTickets: GetTicketResult?
    var arrPayments:[GetAllPaymentDetailsData]?
    var customModel : CustomBokingModel?
    var sessionName = ""
    var sessionDesc = ""
    var chargeId = ""
    
    //MARK: - SESSION DETAIL API
    func sessionDtailApi(user_id: String, session_id: String, latitude: String, longitude: String, top_search: String,bookingId : String) {
        let date = Date().dateInString()
        let prams : [String : Any] = ["user_id": user_id, "session_id": session_id, "latitude": latitude, "longitude": longitude, "top_search": top_search,"currentdatetime" : date,"language" : SaveToDefaults().getAppLang() ?? "en","booking_id" : bookingId]
        self.show()
        api_manager.GETApi(sessionDetailApi(), param: prams, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    let data = try? json["result"].rawData()
                    let jsonDecoder = JSONDecoder()
                    let model = try? jsonDecoder.decode(SessionDetailResult.self, from: data ?? Data())
                    self.model = model
                    self.delegate?.reloadData()
                }
                else {
                    showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
            }
        }
    }
    
    //Api Ticket Avilability (user_id: userid, session_id: id, ticket: "\(tempTkt)", booking_date: self.selectedDate, booking_from_time: fromtime, booking_to_time: toTime, paid_amount: amt, schedule_time_id: timeId)
    func checkTicketAvailabilityApi(user_id: String, session_id: String, latitude: String, longitude: String, ticket: String, booking_date: String, booking_from_time: String, booking_to_time: String, paid_amount: String, schedule_time_id: String,offeredTypeId : String) {
        self.show()
        api_manager.GETApi(check_ticketApi(user_id: user_id, ticket: ticket, schedule_time_id: schedule_time_id), param: nil, header: header()) { [self] (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    
                    self.customModel = CustomBokingModel.init(user_id: user_id, session_id: session_id, latitude: latitude, longitude: longitude, booking_date: booking_date, booking_from_time: booking_from_time, booking_to_time: booking_to_time, paid_amount: paid_amount, schedule_time_id: schedule_time_id, offeredTypeId: offeredTypeId,sessionName: self.sessionName,sessionDesc: self.sessionDesc)
                    self.delegate?.bookingSuccess()
                    
                }else if json["statusCode"] == 300 {
                    showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                }
                else {
                    showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
            }
        }
    }
    
    //MARK: - GET TICKET DATA API
    func getTicketDataApi(user_id: String, session_id: String, schedule_time_id: String) {
        api_manager.GETApi(ticketDataApi(user_id: user_id,  session_id: session_id, schedule_time_id: schedule_time_id), param: nil, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    let data = try? json["result"].rawData()
                    let jsonDecoder = JSONDecoder()
                    let model = try? jsonDecoder.decode(GetTicketResult.self, from: data ?? Data())
                    self.availableTickets = model
                }
                else {
                    showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
            }
        }
    }
    
    //MARK: - METHOD TO GET ALL PAYMENTS
    func getAllPayments(user_id: String,completionHandler:@escaping()->()) {
        api_manager.GETApi(getAllPaymentDetailsUrl(user_id: user_id), param: nil, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    let data = try? json["result"].rawData()
                    let jsonDecoder = JSONDecoder()
                    let model = try? jsonDecoder.decode([GetAllPaymentDetailsData].self, from: data ?? Data())
                    self.arrPayments = model
                    if(self.arrPayments?.count != 0){
                        completionHandler()
                    }
                }
                else {
                    showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
            }
        }
    }
    
    //MARK: - MAKE PAYMENT FROM STRIPE API
    func makePAymentStripe(user_id: String, stripeytoken: String,ammount : String,currency:String,email:String,token:String,sessionId:String,completionHandler:@escaping(String)->()) {
        self.show()
        let param : [String:Any] = ["user_id" : user_id,"amount":ammount,"stripeytoken":stripeytoken,"currency":currency,"email":email,"token":token,"session_id":sessionId]
        api_manager.POSTApi(makePaymentUsingStripe(), param: param, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    print(json)
                    completionHandler(json["transaction_id"].string ?? "")
                }
                else {
                    showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
            }
        }
    }
    //MARK: - TIMING ARRAY PF SPECIFIC DATA API
    func timingArrayOfSpecificDateApi(user_id: String, schedule_id: String, isloader: Bool) {
        let prams : [String : Any] = ["user_id": user_id, "schedule_id": schedule_id,"currenttimezone" : TimeZone.current.identifier,"language" : SaveToDefaults().getAppLang() ?? "en"]
        if isloader {
            self.dismiss()
        } else {
            self.show()
        }
        api_manager.GETApi(session_time_detail(), param: prams, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    // let data = try? json["result"].rawData()
                    let jsonDecoder = JSONDecoder()
                    let model = try? jsonDecoder.decode(AllTimeBase.self, from: json.rawData())
                    self.timeArr = model
                    self.delegate?.sessionTimeDetail()
                    // self.delegate?.reloadData()
                    
                } else if json["statusCode"] == 400 {
                    self.delegate?.reloadTime()
                }
                else {
                    showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
            }
        }
    }
    
    
    //MARK: - GET PREFERENCE ID API
    func getPrefrenceIdApi(price : CGFloat,name : String,desc: String,currency : String){
        let itemsArr : [[String:Any]] = [[ "title": name,
                                           "quantity": 1,
                                           "unit_price": price]]
        
        let payer : [String:Any] = ["email":SaveToDefaults().getEmail() ?? ""]
        
        let param :[String:Any] = ["payer" : payer,"items":itemsArr]
        let headerPrefrence : [String:String] = ["Authorization" : "Bearer APP_USR-7488660032626366-081021-f6a853662803b7ae35548fb1c44b7b5b-790689138",
                                                 "Content-Type" : "application/json"]
        self.show()
        api_manager.POSTApi(getPrefrenceIdUrl(), param: param, header: headerPrefrence,encoding: JSONEncoding.default) { (json, err, statusCode) in
            self.dismiss()
            if let response = json{
                let id = response["id"].stringValue
                self.bookingDelegate?.getPrefrenceId(id: id)
            }
        }
    }
    
    //MARK: - METHOD TO CANCEL SESSION API
    func sessionCancelApi(user_id: String, session_id: String,booking_id : String,isFromPartial : Bool , paymentId: String,ammount : String) {
        self.show()
        let param : [String:Any] = ["user_id" : user_id , "session_id" : session_id,"booking_id":booking_id]
        api_manager.POSTApi(sessionCancelApiUrl(), param: param, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    self.stripeRefundAPI(chargeID: self.chargeId)
                }
                else {
                    showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
            }
        }
    }
    
    //MARK: - STRIPE REFUND API
    func stripeRefundAPI(chargeID:String) {
        self.show()
        let  headers = [
            "Authorization": "Bearer \(stripeSecretKey)",
        ]
        let param : [String:Any] = ["charge" : chargeID]
        api_manager.POSTApi(refundPaymentUsingStripe(), param: param, header: headers) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["status"] == "succeeded" {
                    print("success")
                    self.delegate?.refundAPiResponse()
                }
                else {
                    showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
            }
        }
    }
    //MARK: - PARTIAL REFUND API
    func partialRefundApi(user_id: String, paymentId: String,ammount : String) {
        self.show()
        let param : [String:Any] = ["user_id" : user_id , "payment_id" : paymentId,"amount":ammount]
        api_manager.POSTApi(partialRefundApiUrl(), param: param, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    self.delegate?.refundAPiResponse()
                }
                else {
                    showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
            }
        }
    }
    
    //MARK: - FULL REFUND API
    func fullRefundApi(user_id: String, paymentId: String) {
        self.show()
        let param : [String:Any] = ["user_id" : user_id , "payment_id" : paymentId]
        api_manager.POSTApi(fullRefundApiUrl(), param: param, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    self.delegate?.refundAPiResponse()
                }
                else {
                    showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
            }
        }
    }
    
    //MARK: - SESSION BOOKING API
    func sessionBookingApi(user_id: String, session_id: String, ticket: String, booking_date: String, booking_from_time: String, booking_to_time: String, paid_amount: String, schedule_time_id: String,points : String,session_type_id : String? = "",paymentId : String) {
        var prams = [String : Any]()
        if session_type_id ?? "" == ""{
            prams = ["user_id": user_id, "session_id": session_id, "ticket": ticket, "booking_date": booking_date, "booking_from_time": booking_from_time, "booking_to_time": booking_to_time, "paid_amount": paid_amount, "schedule_time_id": schedule_time_id,"points" : points,"booking_convert_time" : convertLocalToUTC(localTime: booking_from_time) ?? "","language" : SaveToDefaults().getAppLang() ?? "en","payment_id" : paymentId]
        }else{
            prams = ["user_id": user_id, "session_id": session_id, "ticket": ticket, "booking_date": booking_date, "booking_from_time": booking_from_time, "booking_to_time": booking_to_time, "paid_amount": paid_amount, "schedule_time_id": schedule_time_id,"points" : points,"booking_convert_time" : convertLocalToUTC(localTime: booking_from_time) ?? "","language" : SaveToDefaults().getAppLang() ?? "en","session_type_id" : session_type_id ?? "","payment_id" : paymentId]
        }
        
        print(prams)
        self.show()
        api_manager.POSTApi(sessionBookingUrl(), param: prams, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    self.bookingDelegate?.bookingSuccess()
                }
                else {
                    showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
            }
        }
    }
    
    
    func convertLocalToUTC(localTime: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = NSTimeZone.local
        let timeLocal = dateFormatter.date(from: localTime)
        if timeLocal != nil {
            dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
            
            let timeUTC = dateFormatter.string(from: timeLocal!)
            return timeUTC
        }
        return nil
    }
    
}
