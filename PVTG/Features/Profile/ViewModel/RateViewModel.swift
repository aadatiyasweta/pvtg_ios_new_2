//
//  RateViewModel.swift
//  PVTG
//
//  Created by Test Machine on 20/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit

protocol AfterSuccess: class {
    func reloadData()
}

class RateViewModel: BaseVm {
    weak var delegate: AfterSuccess?
    
    func ratevalidation(rating: String, desc: String)-> Bool {
        if rating == "" {
            showAlert(strTitle: emptyStar)
            return false
        }
        if desc == "" {
            showAlert(strTitle: emptyReview)
            return false
        }
        return true
    }
    
    func sessionRatingApi(user_id: String, session_id: String, rating: String, feedback: String, booking_id: String) {
        let prams : [String : Any] = ["user_id": user_id, "session_id": session_id, "rating": rating, "feedback": feedback, "booking_id": booking_id]
        self.show()
        api_manager.POSTApi(sessionRatingUrl(), param: prams, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                   // showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
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
    
}
