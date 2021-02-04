//
//  MoreVC.swift
//  PVTG
//
//  Created by Test Machine on 22/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit

class MoreVC: BaseViewController {
    //MARK:- IBOutlets
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet var vwTblFooter: UIView!
    @IBOutlet weak var tblMore: UITableView!{
        didSet {
            self.tblMore.dataSource = self
            self.tblMore.delegate = self
            self.tblMore.tableFooterView = vwTblFooter
            self.tblMore.register(MoreCell.nib(), forCellReuseIdentifier: MoreCell.ident)
        }
    }
    
    //MARK: Variables
    var moreArr = ["Notifications", "Change Password", "FAQs", "Privacy Policy", "Terms & Conditions", "About Us", "Rate Us", "How It Works", "Signout"]
    var morevm = MoreVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        renderTheColorOfImage()
    }
    
    func renderTheColorOfImage() {
        DispatchQueue.main.async {
            let myImage = UIImage(named: "logoWhite")
            let tintableImage = myImage?.withRenderingMode(.alwaysTemplate)
            self.imgLogo.image = tintableImage
            self.imgLogo.tintColor = UIColor().coloWithHexString(hex: "#A0A0A0")
        }
    }
    
    
}

extension MoreVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.moreArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoreCell.ident, for: indexPath) as? MoreCell else { return UITableViewCell() }
        cell.setMoreOptions(options: self.moreArr[indexPath.row])
        if moreArr.count-1 == indexPath.row {
            cell.lblMore.textColor = UIColor().coloWithHexString(hex: "#ff4949")
            cell.vwSeperator.alpha = 0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = NotificationVC.instance()
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = ChangePasswordVC.instance()
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
             let vc = PrivacyPolicyVC.instance()
             vc.type = "FAQ"
             vc.url = faq
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = PrivacyPolicyVC.instance()
            vc.type = "Privacy Policy"
            vc.url = privacy
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = PrivacyPolicyVC.instance()
            vc.type = "Terms & Condition"
            vc.url = terms
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            let vc = PrivacyPolicyVC.instance()
            vc.type = "About Us"
            vc.url = aboutUs
            self.navigationController?.pushViewController(vc, animated: true)
        case 6:
            debugPrint("Rate us")
//            let vc = RateUsVC.instance()
//            self.navigationController?.pushViewController(vc, animated: true)
        case 7:
            let vc = OnboardingVC.instance()
            vc.controllerId = 1
            self.navigationController?.pushViewController(vc, animated: true)
        case 8:  self.showAlertWithConfirmation("Are you sure you want to signout?", withTitle: "PVTG", itsController: self) { (sucess) in
                       if sucess{
                       // guard let userid = SaveToDefaults().getUserId() else {return}
                                 appDelegate.hitDeviceTokenApi(isLogout: true)
                                 SaveToDefaults().setAccessToken(value: nil)
                                 SaveToDefaults().setLogindata(data: Data())
                                 defaults.synchronize()
                                 let vc = LoginVC.navigation()
                                 window?.rootViewController = vc
                                 window?.makeKeyAndVisible()
                                 //self.morevm.logOutApi(user_id: userid)
                       }
                   }
        default:
            debugPrint("")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
