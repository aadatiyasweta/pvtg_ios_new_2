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
import StoreKit

protocol GetResponse: AnyObject{
    func reloadData()
    func bookingSuccess()
    func allTicketsSold()
    func reloadTime()
    func sessionTimeDetail()
    func refundAPiResponse()
    func soldTicketResponse()
}
protocol GetBookingResponse: AnyObject{
    func bookingSuccess()
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
    var cancellSuccesClosure:() -> (Void) = {   }
    var rescheduleSuccesClosure:() -> (Void) = {   }
    var rescheduleErrorClosure:() -> (Void) = {   }
    //MARK: - SESSION DETAIL API
    func sessionDtailApi(user_id: String, session_id: String, latitude: String, longitude: String, top_search: String,bookingId : String) {
        let date = Date().dateInString()
        let prams : [String : Any] = ["user_id": user_id, "session_id": session_id, "latitude": latitude, "longitude": longitude, "top_search": top_search,"currentdatetime" : date,"language" : SaveToDefaults().getAppLang() ?? "en","booking_id" : bookingId]
        self.show()
        api_manager.GETApi(sessionDetailApi(), param: prams, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
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
                    self.delegate?.soldTicketResponse()
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
#if DEBUG
        guard let units = Int(ammount) else {
            showAlert(strTitle: somethingWentWrongMessage)
            return
        }
        var request = URLRequest(url: URL(string: "https://api.stripe.com/v1/charges")!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(stripeSecretKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = "amount=\(units * 100)&currency=\(currency.lowercased())&source=\(stripeytoken)&description=Debug%20test%20booking".data(using: .utf8)
        self.show()
        URLSession.shared.dataTask(with: request) { data, _, _ in
            let json = (try? JSONSerialization.jsonObject(with: data ?? Data())) as? [String: Any]
            DispatchQueue.main.async {
                self.dismiss()
                if let chargeId = json?["id"] as? String, json?["status"] as? String == "succeeded" {
                    completionHandler(chargeId)
                } else {
                    let error = json?["error"] as? [String: Any]
                    showAlert(strTitle: error?["message"] as? String ?? somethingWentWrongMessage)
                }
            }
        }.resume()
#else
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
#endif
    }
    //MARK: - TIMING ARRAY PF SPECIFIC DATA API
    func timingArrayOfSpecificDateApi(user_id: String, schedule_id: String, isloader: Bool, session_type_id:String, session_type : String, selecteddate:String) {
        let prams : [String : Any] = ["user_id": user_id, "schedule_id": schedule_id,"session_type_id": session_type_id,"currenttimezone" : TimeZone.current.identifier,"language" : SaveToDefaults().getAppLang() ?? "en","session_type" : session_type,"date":selecteddate]
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
    
    
    //MARK: - METHOD TO CANCEL SESSION API
    func sessionCancelApi(user_id: String, session_id: String,booking_id : String,isFromPartial : Bool , paymentId: String,ammount : String, chargeid : String) {
        self.show()
        let param : [String:Any] = ["user_id" : user_id , "session_id" : session_id,"booking_id":booking_id]
        api_manager.POSTApi(sessionCancelApiUrl(), param: param, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    
                    self.stripeRefundAPI(chargeID: chargeid)
                    //showAlert(strTitle: "Session cancelled successfully.")
                    
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
#if DEBUG
        let refundSecretKey = stripeSecretKey
#else
        let refundSecretKey = stripeLiveSecretKey
#endif
        let  headers = [
            "Authorization": "Bearer \(refundSecretKey)", //"stripeSecretKey" --  this is for development
        ] // "stripeLiveSecretKey" --  this is for live
        let param : [String:Any] = ["charge" : chargeID]
        api_manager.POSTApi(refundPaymentUsingStripe(), param: param, header: headers) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["status"] == "succeeded" {
                    print("success")
                    self.cancellSuccesClosure()
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
    func sessionBookingApi(user_id: String, session_id: String, ticket: String, booking_date: String, booking_from_time: String, booking_to_time: String, paid_amount: String, schedule_time_id: String,points : String,session_type_id : String? = "",paymentId : String,session_time_minute : String, selectedSessionSTr : String) {
        var prams = [String : Any]()
        if session_type_id ?? "" == ""{
            prams = ["user_id": user_id, "session_id": session_id, "ticket": ticket, "booking_date": booking_date, "booking_from_time": booking_from_time, "booking_to_time": booking_to_time, "paid_amount": paid_amount, "schedule_time_id": schedule_time_id,"points" : points,"booking_convert_time" : convertLocalToUTC(localTime: booking_from_time) ?? "","language" : SaveToDefaults().getAppLang() ?? "en","payment_id" : paymentId,"session_type_id" : session_type_id ?? "","session_time_minute" : session_time_minute,"session_type" : selectedSessionSTr]
        }else{
            prams = ["user_id": user_id, "session_id": session_id, "ticket": ticket, "booking_date": booking_date, "booking_from_time": booking_from_time, "booking_to_time": booking_to_time, "paid_amount": paid_amount, "schedule_time_id": schedule_time_id,"points" : points,"booking_convert_time" : convertLocalToUTC(localTime: booking_from_time) ?? "","language" : SaveToDefaults().getAppLang() ?? "en","session_type_id" : session_type_id ?? "","payment_id" : paymentId,"session_time_minute" : session_time_minute,"session_type" : selectedSessionSTr]
        }
        
        print(prams)
        self.show()
        api_manager.POSTApi(sessionBookingUrl(), param: prams, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    SKStoreReviewController.requestReview()
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
    
    //MARK: - RESCHEDULE SESSION BOOKING API
    func sessionRescheduleApi(user_id: String, session_id: String, booking_id: String, booking_date: String, booking_from_time: String, booking_to_time: String, schedule_time_id: String,session_type_id : String? = "",rescheduleCount : String,session_time_minute : String,selectedSessionSTr : String) {
        var prams = [String : Any]()
        prams = ["user_id": user_id, "session_id": session_id, "reschedule_count": rescheduleCount, "booking_date": booking_date, "booking_from_time": booking_from_time, "booking_to_time": booking_to_time, "schedule_time_id": schedule_time_id,"booking_id": booking_id,"session_type_id":self.model?.session_type?[0].session_type_id ?? "" ,"language" : SaveToDefaults().getAppLang() ?? "en","session_time_minute" : session_time_minute,"session_type" : selectedSessionSTr]
        print(prams)
        self.show()
        api_manager.POSTApi(rescheduleSessionApiUrl(), param: prams, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                    self.rescheduleSuccesClosure()
                }
                else {
                    showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                    self.rescheduleErrorClosure()
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
