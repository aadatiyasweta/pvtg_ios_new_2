//
//  MoreVC.swift
//  PVTG
//
//  Created by Test Machine on 22/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit
import StoreKit

class MoreVC: BaseViewController {

//MARK: - Outlets
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
 
 //MARK: - Properties
 var moreArr = [R.string.localizable.notifications(), R.string.localizable.changePassword(),R.string.localizable.changeLanguage(), R.string.localizable.faQs(),R.string.localizable.privacyPolicy(),R.string.localizable.termsConditions(),R.string.localizable.cancelPolicy(),R.string.localizable.aboutUs(),R.string.localizable.rateUs(),R.string.localizable.howItWorks(), R.string.localizable.signout()]
 var morevm = MoreVM()
 
//MARK: - LifeCycle
 override func viewDidLoad() {
  super.viewDidLoad()
  renderTheColorOfImage()
 }
 
 func renderTheColorOfImage() {
 }
}

//MARK: - TABLE VIEW DELEGATES
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
   vc.url = cancelPolicy
      vc.isComingCancelBooking = false
   self.navigationController?.pushViewController(vc, animated: true)
  case 7:
   let vc = PrivacyPolicyVC.instance()
   vc.type = self.moreArr[indexPath.row]
   vc.url = aboutUs
   self.navigationController?.pushViewController(vc, animated: true)
  case 8:
   debugPrint("  Rate us")
      SKStoreReviewController.requestReview()
  case 9:
   let vc = OnboardingVC.instance()
   vc.controllerId = 1
   self.navigationController?.pushViewController(vc, animated: true)
  case 10:  self.showAlertWithConfirmation(R.string.localizable.areyousureyouwant(), withTitle: appName, itsController: self) { (sucess) in
   if sucess{
    appDelegate.hitDeviceTokenApi(isLogout: true)
    SaveToDefaults().setAccessToken(value: nil)
    SaveToDefaults().setLogindata(data: Data())
    defaults.synchronize()
//    let vc = LoginVC.navigation()
//    window?.rootViewController = vc
//    window?.makeKeyAndVisible()
       appDelegate.setLoginVC()
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

