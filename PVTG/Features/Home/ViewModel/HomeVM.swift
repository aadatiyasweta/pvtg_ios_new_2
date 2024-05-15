//
//  HomeVM.swift
//  PVTG
//
//  Created by Test Machine on 12/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit
protocol GetHomeData: AnyObject {
 func reloadData(unreadNotificationCount:Int)
}
class HomeVM: BaseVm {
 var model: HomeResult?
  weak var delegate: GetHomeData?
    
    //MARK: - HOME API
    func getHomeApi(user_id: String, category_id: String, latitude: String, longitude: String, search: String, top_search: String, city: String,minPrice : Int? = 0 , maxprice : Int? = 0,currency : String) {
        var prams = [String : Any]()
        if minPrice == 0 && maxprice == 0{
            prams = ["user_id": user_id, "category_id": category_id, "latitude": latitude, "longitude": longitude, "search": search, "top_search": top_search, "city": city,"language" : SaveToDefaults().getAppLang() ?? "en"]
        }else{
            prams = ["user_id": user_id, "category_id": category_id, "latitude": latitude, "longitude": longitude, "search": search, "top_search": top_search, "city": city,"language" : SaveToDefaults().getAppLang() ?? "en", "min_price" : minPrice ?? 0 , "max_price" : maxprice ?? 0,"selected_currency" : currency]
        }
//        if minPrice == 0 && maxprice == 0{
//            prams = ["user_id": "34", "category_id": "", "latitude": "41.15168065288667", "longitude": "16.41554494366934", "search": "", "top_search": "", "city": "Corato","language" : SaveToDefaults().getAppLang() ?? "en"]
//        }else{
//            prams = ["user_id": "34", "category_id": "", "latitude": "41.15168065288667", "longitude": "16.41554494366934", "search": "", "top_search": "", "city": "Corato","language" : SaveToDefaults().getAppLang() ?? "en", "min_price" : minPrice ?? 0 , "max_price" : maxprice ?? 0,"selected_currency" : currency]
//        }
         
        self.show()
        api_manager.POSTApi(gethome(), param: prams, header: header()) { (response, err, code) in
            self.dismiss()
//            let cookieHeader = (prams.compactMap({ (key, value) -> String in
//                return "\(key)=\(value)"
//            }) as Array).joined(separator: ";")
//            
//            let homeUrl = String(describing: gethome())
//            let responseString = String(describing: response)
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    let data = try? json["result"].rawData()
                 let unreadCount = json["unread_notification"].int
                    let jsonDecoder = JSONDecoder()
                    let model = try? jsonDecoder.decode(HomeResult.self, from: data ?? Data())
                    self.model = model
                 self.delegate?.reloadData(unreadNotificationCount: unreadCount ?? 0)
                    
                }
                else {
                    showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                   // showAlert(strTitle: cookieHeader + ":: " + homeUrl + ", " + responseString)
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
               // showAlert(strTitle: cookieHeader + ":: " + homeUrl + ", " + responseString)
            }
        }
    }
}
