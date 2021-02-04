//
//  NotificationViewModel.swift
//  PVTG
//
//  Created by Test Machine on 20/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit

protocol AfterGettingNotificationList: class {
    func updateList()
}

class NotificationViewModel: BaseVm {
    var model: NotificationListBase?
    weak var delegate: AfterGettingNotificationList?
    
    func getCoachNotificationListApi(user_id: String, offset: String) {
        let prams : [String : Any] = ["user_id": user_id, "offset": offset]
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

}
