//
//  SearchSessionViewModel.swift
//  PVTG
//
//  Created by Test Machine on 21/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit
protocol GetSearchSessionData: class {
    func reloadData()
    func colecnreloadData()
}

class SearchSessionViewModel: BaseVm {
    var model: SearchBase?
    weak var delegate: GetSearchSessionData?
    var categorymodel: CategoryBase?
    
    func getAllCategoryApi(user_id: String) {
             let prams : [String : Any] = ["user_id": user_id]
             self.show()
             api_manager.GETApi(sessionallCategoryUrl(), param: prams, header: header()) { (response, err, code) in
                 self.dismiss()
                 if let json = response{
                     debugPrint(json)
                     if json["statusCode"] == 200 {
                         let data = try? json.rawData()
                         let jsonDecoder = JSONDecoder()
                         let model = try? jsonDecoder.decode(CategoryBase.self, from: data ?? Data())
                         self.categorymodel = model
                       self.delegate?.colecnreloadData()
                         
                     }
                     else {
                         showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                     }
                 }else{
                     showAlert(strTitle: somethingWentWrongMessage)
                 }
             }
         }

    
    func searchSessionApi(user_id: String, category_id: String, latitude: String, longitude: String, search: String, isLoader: Bool) {
        let prams : [String : Any] = ["user_id": user_id, "category_id": category_id, "latitude": latitude, "longitude": longitude, "search": search]
        if isLoader {
        self.show()
        } else {
            self.dismiss()
        }
        api_manager.POSTApi(searchSessionUrl(), param: prams, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    let data = try? response?.rawData()
                    let jsonDecoder = JSONDecoder()
                    let model = try? jsonDecoder.decode(SearchBase.self, from: data ?? Data())
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
    
    
}
