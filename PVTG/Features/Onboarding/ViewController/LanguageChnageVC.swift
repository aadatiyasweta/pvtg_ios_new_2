//
//  LanguageChnageVC.swift
//  PVTG
//
//  Created by Techugo on 12/08/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit

class LanguageChnageVC: UIViewController {

    @IBOutlet weak var engBtn: UIButton!
    @IBOutlet weak var englishText: UILabel!
    @IBOutlet weak var spanishBtn: UIButton!
    @IBOutlet weak var spainshLbl: UILabel!
    @IBOutlet weak var gradBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.englishText.text = flag(from: "UK")
//        self.spainshLbl.text = flag(from: "ES")
        self.engBtn.isSelected = true
        sethorizontalGradient(view: self.gradBtn, colors: [#colorLiteral(red: 0, green: 0.8823529412, blue: 0.7254901961, alpha: 1),#colorLiteral(red: 0.3411764706, green: 0.3411764706, blue: 1, alpha: 1)])
        self.spanishBtn.alpha = 0.5
    }
    
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
    @IBAction func nextBtnTap(_ sender: UIButton) {
        if spanishBtn.isSelected{
            SaveToDefaults().setAppLang(value: "es")
        }else{
            SaveToDefaults().setAppLang(value: "en")
        }
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
    func flag(from country:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.uppercased().unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return s
    }
}
