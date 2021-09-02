//
//  HomeVM.swift
//  PVTG
//
//  Created by Test Machine on 12/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit
protocol GetHomeData: class {
    func reloadData()
}
class HomeVM: BaseVm {
    var model: HomeResult?
  weak var delegate: GetHomeData?
    
    func getHomeApi(user_id: String, category_id: String, latitude: String, longitude: String, search: String, top_search: String, city: String,minPrice : Int? = 0 , maxprice : Int? = 0) {
        var prams = [String : Any]()
        if minPrice == 0 && maxprice == 0{
            prams = ["user_id": user_id, "category_id": category_id, "latitude": latitude, "longitude": longitude, "search": search, "top_search": top_search, "city": city,"language" : SaveToDefaults().getAppLang() ?? "en"]
        }else{
            prams = ["user_id": user_id, "category_id": category_id, "latitude": latitude, "longitude": longitude, "search": search, "top_search": top_search, "city": city,"language" : SaveToDefaults().getAppLang() ?? "en", "min_price" : minPrice ?? 0 , "max_price" : maxprice ?? 0]
        }
         
        self.show()
        api_manager.POSTApi(gethome(), param: prams, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    let data = try? json["result"].rawData()
                    let jsonDecoder = JSONDecoder()
                    let model = try? jsonDecoder.decode(HomeResult.self, from: data ?? Data())
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
