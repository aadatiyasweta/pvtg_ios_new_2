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
        if SaveToDefaults().getAppLang() ?? "en" == "en" || SaveToDefaults().getAppLang() == nil{
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
