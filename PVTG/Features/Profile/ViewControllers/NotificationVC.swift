//
//  NotificationVC.swift
//  NPNGCoachApp
//
//  Created by Test Machine on 30/10/20.
//  Copyright © 2020 Techugo. All rights reserved.
//

import UIKit

class NotificationVC: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tblNotication: UITableView!{
        didSet {
            tblNotication.dataSource = self
            tblNotication.delegate = self
        }
    }
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lbvlNoNotification: UILabel!
    
    //MARK: - Properties
    let arrayHead = "john doe has invited to you for join a session"
    private var notificationVM = NotificationViewModel()
    var arrNotificationresult = [NotificationListResult]()
    var indexOfPageToRequest = 0
    var ispageEnabled = false
    
    var bookigIdSTr = ""
    var sessionIdSTr = ""
    var rescheduleCountSTr = ""
    var sessionTitleStr = ""
    
    var amountSTr = ""
    var paymentIdStr = ""
    var chargeIdSTr = ""
    var bookingDateSTr = ""
    
    var notificationListData = [NotificationListResult]()
   // var window: UIWindow?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bookigIdSTr = ""
        self.tabBarController?.removeBadgeSubview()
        self.notificationVM.delegate = self
       
        self.tblNotication.register(NotificationCell.nib(), forCellReuseIdentifier: NotificationCell.ident)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationListData.removeAll()
        loadApi(offset: "0")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setVSViewShadow(radius: 10, color: .black, view: self.btnBack, opacity: 0.12)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
            if arrNotificationresult.count > 0{
                indexOfPageToRequest += 10
                let data = String(indexOfPageToRequest)
                loadApi(offset: data)
                print(data)
            }else{
                noNotification(isHidden: true, text: "")
            }
        }
    }
    
    //"Your session begins in 3 hours, will you still be attending your session?" ---  previously it was
    func performAttendingAlert(id : String, bookingId: String, rescheduleCount: String){
        Helper.shared.showAlertWithCallback(buttonText: R.string.localizable.yes(), buttonText2: R.string.localizable.no(), title: R.string.localizable.notificationtitle(), message: "Your session begins soon, will you still be attending your " + sessionTitleStr + " session?", controller: AppObject.window?.rootViewController ?? UIViewController()) { [weak self] result in
            guard let self else{return}
            if result{
               // self.hitApi(id: "\(id)")
                Helper.shared.showAlertWithCallback(buttonText:  R.string.localizable.view(), buttonText2: R.string.localizable.later() , title: R.string.localizable.viewpolicy(), message: R.string.localizable.viewLatePolicy(), controller: AppObject.window?.rootViewController ?? UIViewController()) { [weak self] result in
                        guard let self else{return}
                        if result{
                            print("Yes Clicked")
                            let vc = PrivacyPolicyVC.instance()
                            vc.type = R.string.localizable.latePolicy()
                            vc.isFromReschedule = true
                            vc.rescheduleCountStr = rescheduleCount
                            //vc.url = cancelPolicy
                            vc.url = "https://techugoserver.info/pvtg_dev/late_fee.html"
                            vc.isComingCancelBooking = false
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else{
                           
                            }
                        }
                    }
            else { // here after first click no
                Helper.shared.showAlertWithCallback(buttonText: R.string.localizable.reschedule(), buttonText2: R.string.localizable.no(), title: R.string.localizable.notificationtitle(), message: R.string.localizable.rescheduleSession(), controller: AppObject.window?.rootViewController ?? UIViewController()) { [weak self] result in
                            guard let self else{return}
                    if result{
                        print("Yes Clicked")
                        let vc = SessionDetailVC.instance()
                            vc.controllerId = 1
                            vc.bookingId = self.bookigIdSTr
                            vc.sessionId = self.sessionIdSTr
                            vc.rescheduleCountStr = self.rescheduleCountSTr
                            self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                                print("no ")
//                                let vc = SessionDetailVC.instance()
//                                vc.sessionId = "\(id)"
//                                vc.bookingId = bookingId
//                                vc.rescheduleCountStr = rescheduleCount
//                                vc.controllerId = 0
//                                //vc.isFromReschedule = true
//                                //vc.isFromRescheduleNo = false
//                                self.navigationController?.pushViewController(vc, animated: true)
                        let vc = PrivacyPolicyVC.instance()
                        vc.type = R.string.localizable.cancelPolicy()
                        vc.isFromReschedule = true
                        vc.bookingId = bookingId
                        vc.rescheduleCountStr = rescheduleCount
                        vc.url = cancelPolicy
                        vc.isComingCancelBooking = true
                        vc.sessionId = self.sessionIdSTr
                        vc.getChargeId = chargeIdSTr
                        vc.timeStr = bookingDateSTr
                        vc.payment_id = paymentIdStr
                        vc.ammountSTr = amountSTr
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                            }
                    }
                }
            }
    }
}

//MARK: - TABLE VIEW DELEGATE AND DATASOURCE
extension NotificationVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationVM.model?.result?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.ident, for: indexPath) as? NotificationCell else {return UITableViewCell()}
        cell.setData(data: self.notificationVM.model?.result?[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("\(indexPath.row)")
        
        bookigIdSTr = self.notificationListData[indexPath.row].booking_id ?? ""
        sessionIdSTr = self.notificationListData[indexPath.row].session_id ?? ""
        rescheduleCountSTr = self.notificationListData[indexPath.row].reschedule_count ?? ""
        sessionTitleStr = self.notificationListData[indexPath.row].name_of_listing ?? ""
        
        amountSTr = self.notificationListData[indexPath.row].amount ?? ""
        paymentIdStr = self.notificationListData[indexPath.row].payment_id ?? ""
        chargeIdSTr = self.notificationListData[indexPath.row].charge_id ?? ""
        bookingDateSTr = self.notificationListData[indexPath.row].booking_date ?? ""
        
        guard let userid = SaveToDefaults().getUserId() else {return}
        
        //self.notificationVM.getCoachNotificationListApi(user_id: userid, offset: offset)
        self.notificationVM.makeCheckSession(user_id: userid, session_id: sessionIdSTr, schedule_time_id: self.notificationListData[indexPath.row].schedule_time_id ?? "", booking_id: bookigIdSTr)
    }
}

//MARK: - VIEW CONTROLLER EXTENSION
extension NotificationVC {
    private func loadApi(offset: String) {
        guard let userid = SaveToDefaults().getUserId() else {return}
        self.notificationVM.getCoachNotificationListApi(user_id: userid, offset: offset)
    }
    
    func noNotification(isHidden: Bool, text: String){
        lbvlNoNotification.isHidden = isHidden
        lbvlNoNotification.text = text
        ispageEnabled = isHidden
    }
}

//MARK: - CUSTOM DELEGATE
extension NotificationVC: AfterGettingNotificationList {
    func updateCheckRescheduleStatus() {
        performAttendingAlert(id: self.sessionIdSTr, bookingId: self.bookigIdSTr, rescheduleCount: self.rescheduleCountSTr)
//        
//        Helper.shared.showAlertWithCallback(buttonText: R.string.localizable.reschedule(), buttonText2: R.string.localizable.no(), title: R.string.localizable.notificationtitle(), message: R.string.localizable.rescheduleSession(), controller: AppObject.window?.rootViewController ?? UIViewController()) { [weak self] result in
//            guard let self else{return}
//            if result{
//                let vc = SessionDetailVC.instance()
//                    vc.controllerId = 1
//                    vc.bookingId = self.bookigIdSTr
//                    vc.sessionId = self.sessionIdSTr
//                    vc.rescheduleCountStr = self.rescheduleCountSTr
//                    self.navigationController?.pushViewController(vc, animated: true)
//            }else{
//                print("no ")
//               
//            }
//    }

        
        
        
//        let refreshAlert = UIAlertController(title: R.string.localizable.notificationtitle(), message: R.string.localizable.rescheduleSession(), preferredStyle: UIAlertController.Style.alert)
//        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
//            refreshAlert.dismiss(animated: true, completion: nil)
//        }))
//                refreshAlert.addAction(UIAlertAction(title: R.string.localizable.reschedule(), style: .default, handler: { (action: UIAlertAction!) in
//
//                    let vc = SessionDetailVC.instance()
//                    vc.controllerId = 1
//                    vc.bookingId = self.bookigIdSTr
//                    vc.sessionId = self.sessionIdSTr
//                    vc.rescheduleCountStr = self.rescheduleCountSTr
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }))
//
//                present(refreshAlert, animated: true, completion: nil)
        
        print("StatusSucess")

    }
    
    func updateList() {
        if self.notificationVM.model?.result?.count ?? 0 > 0 {
            self.lbvlNoNotification.text = ""
            notificationListData += self.notificationVM.model?.result ?? [NotificationListResult]()
            
        } else {
            self.lbvlNoNotification.text = R.string.localizable.noNotifications()
        }
        self.tblNotication.reloadData()
        loadUpdateNotificationStatusAPI()
    }
    
    private func loadUpdateNotificationStatusAPI() {
        guard let userid = SaveToDefaults().getUserId() else {return}
        self.notificationVM.updateNotificationStatus(user_Id: userid)
    }
}
