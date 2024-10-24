//
//  LanguageChnageVC.swift
//  PVTG
//
//  Created by Techugo on 12/08/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit

class LanguageChnageVC: BaseViewController {

    //MARK: - Outlets
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var engBtn: UIButton!
    @IBOutlet weak var englishText: UILabel!
    @IBOutlet weak var spanishBtn: UIButton!
    @IBOutlet weak var spainshLbl: UILabel!
    @IBOutlet weak var gradBtn: UIButton!
    
    //MARK: - Properties
    var isFromProfile = false
    
   //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backBtn.isHidden = !self.isFromProfile
        sethorizontalGradient(view: self.gradBtn, colors: [#colorLiteral(red: 0, green: 0.8823529412, blue: 0.7254901961, alpha: 1),#colorLiteral(red: 0.3411764706, green: 0.3411764706, blue: 1, alpha: 1)])
        self.spanishBtn.alpha = 0.5
        if SaveToDefaults().getAppLang() ?? "en" == "en"{
            self.spanishBtn.alpha = 0.5
            self.engBtn.alpha = 1
            self.spanishBtn.isSelected = false
            self.engBtn.isSelected = true
        }else{
            self.engBtn.alpha = 0.5
            self.spanishBtn.alpha = 1
            self.engBtn.isSelected = false
            spanishBtn.isSelected = true
        }
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func engBtnTap(_ sender: UIButton) {
        self.spanishBtn.alpha = 0.5
        self.engBtn.alpha = 1
        self.spanishBtn.isSelected = false
        sender.isSelected = true
    }
    
    @IBAction func spainishBtn(_ sender: UIButton) {
        self.engBtn.alpha = 0.5
        self.spanishBtn.alpha = 1
        self.engBtn.isSelected = false
        sender.isSelected = true
    }
    
    func hitChangeLanguageApi(){
        let param : [String:Any] = [
            "user_id" : SaveToDefaults().getUserId() ?? "",
            "language" : SaveToDefaults().getAppLang() ?? "en"
        ]
        print(header() ?? [:])
        api_manager.PUTApi(changeLanguageUrl(), param: param, header: header()) { (response, err, stausCode) in
            print(response ?? "Nil")
        }
    }
    
    @IBAction func nextBtnTap(_ sender: UIButton) {
        if self.isFromProfile{
            if spanishBtn.isSelected{
                SaveToDefaults().setAppLang(value: "es")
            }else{
                SaveToDefaults().setAppLang(value: "en")
            }
            Bundle.setLanguage(SaveToDefaults().getAppLang() ?? "en")
            self.hitChangeLanguageApi()
            
//            let vc = TabBarControllerViewController.navigation()
//            window?.rootViewController = vc
//            window?.makeKeyAndVisible()
            appDelegate.setTabBarControllerVC()
        }else{
            if spanishBtn.isSelected{
                SaveToDefaults().setAppLang(value: "es")
            }else{
                SaveToDefaults().setAppLang(value: "en")
            }
            Bundle.setLanguage(SaveToDefaults().getAppLang() ?? "en")
            if SaveToDefaults().getAccessToken() == nil || SaveToDefaults().getAccessToken() == "" {
                if SaveToDefaults().getIsNew() == nil || SaveToDefaults().getIsNew() == false {
//                    let vc = OnboardingVC.navigation()
//                    window?.rootViewController = vc
//                    window?.makeKeyAndVisible()
                    appDelegate.setOnboardingVC()
                    
                } else{
//                    let vc = LoginVC.navigation()
//                    window?.rootViewController = vc
//                    window?.makeKeyAndVisible()
                    appDelegate.setLoginVC()
                }
            } else {
//                let vc = TabBarControllerViewController.navigation()
//                window?.rootViewController = vc
//                window?.makeKeyAndVisible()
                appDelegate.setTabBarControllerVC()
            }
        }
    }
    
    func flag(from country:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.uppercased().unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return s
    }
}
