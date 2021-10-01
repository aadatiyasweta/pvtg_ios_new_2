//
//  SplashVC.swift
//  NPNGUserApp
//
//  Created by Techugo on 25/08/20.
//  Copyright © 2020 Techugo. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class SplashVC:UIViewController {
    
    //    @IBOutlet weak var viewPlayer: UIView!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5, execute: {
           self.checkLoginStatus()
        })
    }

    func checkLoginStatus() {
        if SaveToDefaults().getAppLang() ?? "" == "" || SaveToDefaults().getAppLang() == nil{
            let vc = LanguageChnageVC.navigation()
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
        }else{
            if SaveToDefaults().getAccessToken() == nil || SaveToDefaults().getAccessToken() == "" {
                if SaveToDefaults().getIsNew() == nil || SaveToDefaults().getIsNew() == false {
                    let vc = OnboardingVC.navigation()
                    window?.rootViewController = vc
                    window?.makeKeyAndVisible()
                    
                } else{
                    let vc = LoginVC.navigation()
                    window?.rootViewController = vc
                    window?.makeKeyAndVisible()
                }
            } else {
                let vc = TabBarControllerViewController.navigation()
                window?.rootViewController = vc
                window?.makeKeyAndVisible()
            }
        }
          
       }

}
//Sessionapi/search http://52.27.53.102/pvtg/api/v1/Sessionapi/search
//Token -------->>>>>> B4J86g1oMT
//Header :---:  ["HTTP_APPKEY": "B4J86g1oMT"]
//["search": "", "user_id": "13", "category_id": "5", "latitude": "3.5013135", "max_price": 300, "selected_currency": "$", "min_price": 0, "language": "en", "longitude": "-72.8725054"]
//gethome http://52.27.53.102/pvtg/api/v1/Sessionapi/home
//Token -------->>>>>> B4J86g1oMT
//Header :---:  ["HTTP_APPKEY": "B4J86g1oMT"]
//["category_id": "5", "top_search": "", "user_id": "13", "city": "Colombia", "latitude": "3.5013135", "search": "", "language": "en", "longitude": "-72.8725054"]
