//
//  MoreVM.swift
//  PVTG
//
//  Created by Test Machine on 11/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit

class MoreVM: BaseVm {
    //API to LogOut
    func logOutApi(user_id: String) {
        let params : [String: Any] = ["user_id": user_id,"language" : SaveToDefaults().getAppLang() ?? "en"]
        debugPrint(params)
        self.show()
        api_manager.GETApi(logOutUrl(), param: params, header: header()) {(response, err, code) in
            self.dismiss()
            if let json = response {
                debugPrint(json)
                if json["statusCode"] == 200 {
                    SaveToDefaults().setAccessToken(value: nil)
                    SaveToDefaults().setLogindata(data: Data())
                    defaults.synchronize()

                    let vc = LoginVC.navigation()
                    window?.rootViewController = vc
                    window?.makeKeyAndVisible()
                }
                else {
                   // showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
            }
        }
    }
}

