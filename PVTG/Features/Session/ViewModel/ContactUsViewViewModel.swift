//
//  ContactUsViewViewModel.swift
//  PVTG
//
//  Created by Techugo on 15/03/24.
//  Copyright © 2024 ShubhamMacmini. All rights reserved.
//

import Foundation
import UIKit


class ContactUsViewViewModel: BaseVm {
    
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
    var contactUsSuccesClosure:() -> (Void) = {   }
    
    //MARK: - RESCHEDULE SESSION BOOKING API
    func contactUsApi(user_id: String, session_id: String, message: String, email: String, name: String) {
        var prams = [String : Any]()
        prams = ["user_id": user_id, "session_id": session_id, "message": message, "email": email, "name": name]
        print(prams)
        self.show()
        api_manager.POSTApi(contactUsApiUrl(), param: prams, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                    self.contactUsSuccesClosure()
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
