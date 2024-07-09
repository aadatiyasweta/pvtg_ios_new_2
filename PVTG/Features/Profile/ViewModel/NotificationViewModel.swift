//
//  NotificationViewModel.swift
//  PVTG
//
//  Created by Test Machine on 20/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit

protocol AfterGettingNotificationList: AnyObject {
    func updateList()
    func updateCheckRescheduleStatus()
}

//protocol CheckRescheduleStatus: AnyObject {
////    func updateCheckRescheduleStatus()
//}

class NotificationViewModel: BaseVm {
    
    //MARK: - Properties
    var model: NotificationListBase?
    weak var delegate: AfterGettingNotificationList?
    
    //weak var delegateCheckStatus: CheckRescheduleStatus?
    var successfulMsg = ""
    
    //MARK: -  Method to get Coach Notification List
    func getCoachNotificationListApi(user_id: String, offset: String) {
        let prams : [String : Any] = ["user_id": user_id, "offset": offset,"language" : SaveToDefaults().getAppLang() ?? "en"]
        self.show()
        api_manager.GETApi(getCoachNotificationList(), param: prams, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    let data = try? response?.rawData()
                    let jsonDecoder = JSONDecoder()
                    let model = try? jsonDecoder.decode(NotificationListBase.self, from: data ?? Data())
                    self.model = model
                    self.delegate?.updateList()
                }
                else {
                    showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
            }
        }
    }
    
    //MARK: - makeCheckSession API
    func makeCheckSession(user_id: String, session_id: String,schedule_time_id : String) {
        let prams : [String : Any] = ["user_id": user_id, "session_id": session_id, "schedule_time_id": schedule_time_id]
        self.show()
        api_manager.POSTApi(checkSession(), param: prams, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
                if json["statusCode"].intValue == 200{
                   // self.successfulMsg = json["APICODERESULT"].stringValue
                    self.delegate?.updateCheckRescheduleStatus()
                }else{
                         showAlert(strTitle: json["APICODERESULT"].stringValue)
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
            }
        }
    }
    
    
    //MARK: - METHOD TO UPDATE NOTIFICATION STATUS
    func updateNotificationStatus(user_Id:String) {
        self.show()
        let prams : [String : Any] = ["user_id": user_Id]
        api_manager.GETApi(updateNotificationStatusUrl(), param: prams, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    let jsonDecoder = JSONDecoder()
                    let data = try? json["result"].rawData()
                    let model = try? jsonDecoder.decode(NotificationListBase.self, from: data ?? Data())
                    self.model = model
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
