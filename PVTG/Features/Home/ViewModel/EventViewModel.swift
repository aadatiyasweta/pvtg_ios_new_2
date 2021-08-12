//
//  EventViewModel.swift
//  PVTG
//
//  Created by Test Machine on 15/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit

protocol LoadingEvents: class {
    func colecnreloaddata()
    func tblReloadData()
}

class EventViewModel: BaseVm {
    var model: EventsBase?
    weak var delegate: LoadingEvents?
    func getActiveEventApi(user_id: String, latitude: String, longitude: String, offset: String) {
        let prams : [String : Any] = ["user_id": user_id, "latitude": latitude, "longitude": longitude, "offset": offset,"language" : SaveToDefaults().getAppLang() ?? "en"]
          self.show()
          api_manager.GETApi(activeEventApi(), param: prams, header: header()) { (response, err, code) in
              self.dismiss()
              if let json = response{
                  debugPrint(json)
                  if json["statusCode"] == 200 {
                    let data = try? response?.rawData()
                      let jsonDecoder = JSONDecoder()
                      let model = try? jsonDecoder.decode(EventsBase.self, from: data ?? Data())
                      self.model = model
                 
                    self.delegate?.colecnreloaddata()
                      
                  }
                  else {
                      showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                  }
              }else{
                  showAlert(strTitle: somethingWentWrongMessage)
              }
          }
      }
    func getHistoryEventApi(user_id: String, latitude: String, longitude: String) {
             let prams : [String : Any] = ["user_id": user_id, "latitude": latitude, "longitude": longitude,"language" : SaveToDefaults().getAppLang() ?? "en"]
             self.show()
             api_manager.GETApi(historySessionApi(), param: prams, header: header()) { (response, err, code) in
                 self.dismiss()
                 if let json = response{
                     debugPrint(json)
                     if json["statusCode"] == 200 {
                         let data = try? json["result"].rawData()
                         let jsonDecoder = JSONDecoder()
                         let model = try? jsonDecoder.decode(EventsBase.self, from: data ?? Data())
                         self.model = model
                        self.delegate?.tblReloadData()
                         
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
