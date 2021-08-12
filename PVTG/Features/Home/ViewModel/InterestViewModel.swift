//
//  InterestViewModel.swift
//  PVTG
//
//  Created by Test Machine on 21/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit
protocol LoadingCategory: class {
    func reloaddata()
    func fillSelectedArray()
}
class InterestViewModel: BaseVm {
    var model: CategoryBase?
    weak var delegate: LoadingCategory?
    
    func getAllCategoryApi(user_id: String) {
             self.show()
        api_manager.GETApi(allCategoryUrl(userid: user_id), param: nil, header: header()) { (response, err, code) in
                 self.dismiss()
                 if let json = response{
                     debugPrint(json)
                     if json["statusCode"] == 200 {
                         let data = try? json.rawData()
                         let jsonDecoder = JSONDecoder()
                         let model = try? jsonDecoder.decode(CategoryBase.self, from: data ?? Data())
                         self.model = model
                       self.delegate?.reloaddata()
                         
                     }
                     else {
                         showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                     }
                 }else{
                     showAlert(strTitle: somethingWentWrongMessage)
                 }
             }
         }
    
    func userSelectedCategoryApi(user_id: String, selected_category: String) {
        let prams : [String : Any] = ["user_id": user_id, "selected_category": selected_category,"language" : SaveToDefaults().getAppLang() ?? "en"]
                self.show()
                api_manager.PUTApi(selectInterestUrl(), param: prams, header: header()) { (response, err, code) in
                    self.dismiss()
                    if let json = response{
                        debugPrint(json)
                        if json["statusCode"] == 200 {
                          // showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                          self.delegate?.fillSelectedArray()
                            
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
