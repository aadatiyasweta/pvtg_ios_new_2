//
//  SessionDetailViewModel.swift
//  PVTG
//
//  Created by Test Machine on 13/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit


protocol GetResponse: class{
    func reloadData()
    func bookingSuccess()
    func allTicketsSold()
    func reloadTime()
}
protocol GetBookingResponse: class{
      func bookingSuccess()
}
class SessionDetailViewModel: BaseVm {
    var model: SessionDetailResult?
    weak var delegate: GetResponse?
     weak var bookingDelegate: GetBookingResponse?
    var timeArr: AllTimeBase?
    var availableTickets: GetTicketResult?
    var customModel : CustomBokingModel?

    
    func sessionDtailApi(user_id: String, session_id: String, latitude: String, longitude: String, top_search: String) {
        let prams : [String : Any] = ["user_id": user_id, "session_id": session_id, "latitude": latitude, "longitude": longitude, "top_search": top_search]
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
    
    //Api Ticket Avilability (user_id: userid, session_id: id, ticket: "\(tempTkt)", booking_date: self.selectedDate, booking_from_time: fromtime, booking_to_time: toTime, paid_amount: amt, schedule_time_id: timeId)
    func checkTicketAvailabilityApi(user_id: String, session_id: String, latitude: String, longitude: String, ticket: String, booking_date: String, booking_from_time: String, booking_to_time: String, paid_amount: String, schedule_time_id: String) {
        self.show()
        api_manager.GETApi(check_ticketApi(user_id: user_id, ticket: ticket, schedule_time_id: schedule_time_id), param: nil, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                 
                    self.customModel = CustomBokingModel.init(user_id: user_id, session_id: session_id, latitude: latitude, longitude: longitude, booking_date: booking_date, booking_from_time: booking_from_time, booking_to_time: booking_to_time, paid_amount: paid_amount, schedule_time_id: schedule_time_id)
                       self.delegate?.bookingSuccess()
                    
                //    self.sessionBookingApi(user_id: user_id, session_id: session_id, ticket: ticket, booking_date: booking_date, booking_from_time: booking_from_time, booking_to_time: booking_to_time, paid_amount: paid_amount, schedule_time_id: schedule_time_id)
                    // let data = try? json["result"].rawData()
                    
                }else if json["statusCode"] == 300 {
                    showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                   // self.delegate?.allTicketsSold()
                }
                else {
                    showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
            }
        }
    }
    
    //GetTicket Data
    func getTicketDataApi(user_id: String, session_id: String, schedule_time_id: String) {
       //self.show()
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
    
    //For gettingTime Of specific Date
    func timingArrayOfSpecificDateApi(user_id: String, schedule_id: String, isloader: Bool) {
        let prams : [String : Any] = ["user_id": user_id, "schedule_id": schedule_id]
        if isloader {
            self.dismiss()
        } else {
        self.show()
        }
        //url change karna h
        
        api_manager.GETApi(session_time_detail(), param: prams, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                   // let data = try? json["result"].rawData()
                    let jsonDecoder = JSONDecoder()
                    let model = try? jsonDecoder.decode(AllTimeBase.self, from: json.rawData())
                    self.timeArr = model
                    
                    self.delegate?.reloadData()
                    
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
    
    func sessionBookingApi(user_id: String, session_id: String, ticket: String, booking_date: String, booking_from_time: String, booking_to_time: String, paid_amount: String, schedule_time_id: String,points : String) {
        let prams : [String : Any] = ["user_id": user_id, "session_id": session_id, "ticket": ticket, "booking_date": booking_date, "booking_from_time": booking_from_time, "booking_to_time": booking_to_time, "paid_amount": paid_amount, "schedule_time_id": schedule_time_id,"points" : points]
                   self.show()
                   api_manager.POSTApi(sessionBookingUrl(), param: prams, header: header()) { (response, err, code) in
                       self.dismiss()
                       if let json = response{
                           debugPrint(json)
                           if json["statusCode"] == 200 {
        
                             self.bookingDelegate?.bookingSuccess()
                               
                           }
                           else {
                           }
                       }else{
                           showAlert(strTitle: somethingWentWrongMessage)
                       }
                   }
               }
    
}
