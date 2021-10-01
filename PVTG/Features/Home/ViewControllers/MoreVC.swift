//
//  MoreVC.swift
//  PVTG
//
//  Created by Test Machine on 22/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit
import MercadoPagoSDK

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
    var moreArr = [R.string.localizable.notifications(), R.string.localizable.changePassword(),R.string.localizable.changeLanguage(), R.string.localizable.faQs(),R.string.localizable.privacyPolicy(),R.string.localizable.termsConditions(),R.string.localizable.aboutUs(),R.string.localizable.rateUs(),R.string.localizable.howItWorks(), R.string.localizable.signout()]
    var morevm = MoreVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        renderTheColorOfImage()
    }
    
    func renderTheColorOfImage() {
//        DispatchQueue.main.async {
//            let myImage = UIImage(named: "logoLi")
//            let tintableImage = myImage?.withRenderingMode(.alwaysTemplate)
//            self.imgLogo.image = tintableImage
//            self.imgLogo.tintColor = UIColor().coloWithHexString(hex: "#A0A0A0")
//        }
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
            let vc = LanguageChnageVC.instance()
            vc.isFromProfile = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
             let vc = PrivacyPolicyVC.instance()
            vc.type = self.moreArr[indexPath.row]
             vc.url = faq
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = PrivacyPolicyVC.instance()
            vc.type = self.moreArr[indexPath.row]
            vc.url = privacy
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            let vc = PrivacyPolicyVC.instance()
            vc.type = self.moreArr[indexPath.row]
            vc.url = terms
            self.navigationController?.pushViewController(vc, animated: true)
        case 6:
            let vc = PrivacyPolicyVC.instance()
            vc.type = self.moreArr[indexPath.row]
            vc.url = aboutUs
            self.navigationController?.pushViewController(vc, animated: true)
        case 7:

       //   doPayment()
            debugPrint("  Rate us")
//            let vc = RateUsVC.instance()
//            self.navigationController?.pushViewController(vc, animated: true)
        case 8:
            let vc = OnboardingVC.instance()
            vc.controllerId = 1
            self.navigationController?.pushViewController(vc, animated: true)
        case 9:  self.showAlertWithConfirmation(R.string.localizable.areyousureyouwant(), withTitle: appName, itsController: self) { (sucess) in
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

/*
let builder = MercadoPagoCheckoutBuilder(publicKey: "APP_USR-4d43af42-94a6-4e7f-a91f-ca66b4af4e75", preferenceId: "747633178-3b14c159-f4ab-47f3-aaa8-ee719d8e26bb")
let checkout = MercadoPagoCheckout(builder: builder)
let config = PXAdvancedConfiguration()
   builder.setAdvancedConfiguration(config: config)
   builder.setColor(checkoutColor: .green)
//
// builder.setPrivateKey(key: "TEST-8427147478159404-042220-786a65b03356764d1acbfed864a5bb10-747633178")
builder.setPrivateKey(key: "APP_USR-8427147478159404-042220-69597ecf27f3d412ae63890085bfe6fa-747633178")
if let myNavigationController = navigationController {
    checkout.start(navigationController: myNavigationController)
 //TEST-8427147478159404-042220-786a65b03356764d1acbfed864a5bb10-747633178
 //TEST-6ca94e5d-05cc-4365-9091-d63a3065b877
}
*/
