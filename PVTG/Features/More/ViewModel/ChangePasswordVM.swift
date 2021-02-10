//
//  ChangePasswordVM.swift
//  NPNGCoachApp
//
//  Created by Test Machine on 28/08/20.
//  Copyright © 2020 Techugo. All rights reserved.
//
import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import SVProgressHUD

@objc protocol ChangePassword {
    func getReponse()
}

class ChangePasswordVM: BaseVm {
    weak var delegateChangePassword: ChangePassword?
    var successfulMsg = ""
    
    func changePasswordApi(user_id: String, old_password: String, new_password: String) {
        let prams : [String : Any] = ["user_id": user_id, "old_password": old_password, "new_password": new_password]
        self.show()
        api_manager.POSTApi(changePasswordUrl(), param: prams, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
              
                if json["statusCode"].intValue == 200{
                    self.successfulMsg = json["message"].stringValue
                   // showAlert(strTitle: json["message"].stringValue)
                    
                    self.delegateChangePassword?.getReponse()
                }else{
                         showAlert(strTitle: json["APICODERESULT"].stringValue)
                        //self.delegate?.userExist()
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
                showMesssgeWindow(msg: somethingWentWrongMessage)
            }
        }
    }
}
