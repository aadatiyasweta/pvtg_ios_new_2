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
//    @IBOutlet weak var tblNotication: UITableView!{
////        didSet {
////            tblNotication.dataSource = self
////            tblNotication.delegate = self
////        }
//    }
    
    @IBOutlet weak var tblNotication: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lbvlNoNotification: UILabel!
    
    //MARK: - Properties
    let arrayHead = "john doe has invited to you for join a session"
    private var notificationVM = NotificationViewModel()
    
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
    
    var arrNotificationresult = [NotificationListResult]()
    var offset = 0
    var apiHit = true
    
    //var notificationListData = [NotificationListResult]()
   // var window: UIWindow?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bookigIdSTr = ""
        self.tabBarController?.removeBadgeSubview()
        UserDefaults.standard.set(0, forKey: "unreadNotificationCount")
        self.notificationVM.delegate = self
       
        self.tblNotication.register(NotificationCell.nib(), forCellReuseIdentifier: NotificationCell.ident)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrNotificationresult.removeAll()
       // loadApi(offset: "0")
        offset = 0
        loadApi()
    }
    
    func loadApi() {
        guard let userid = SaveToDefaults().getUserId() else {return}
        self.notificationVM.getCoachNotificationListApi(user_id: userid, offset: "\(self.offset)", limit: "10")
        self.notificationVM.SuccesClosuredata = {[weak self] shortData in
            self?.getSuccessNotificationListData(shortData:shortData)
        }
    }
    
    func getSuccessNotificationListData(shortData:[NotificationListResult]){
        
        if self.offset == 0 {
            self.arrNotificationresult.removeAll()
            self.tblNotication.contentOffset = CGPoint(x: 0.0, y: 0.0)
        }
        self.arrNotificationresult += shortData
        self.offset += 1
        
        if shortData.count > 9 {
            self.apiHit = true
        }
        else{
            self.apiHit = false
        }
        if self.arrNotificationresult.count == 0{
//            noDataFoundLbl.isHidden = false
//            noDataFoundLbl.text = "No Feed Found!"
//            feedListTbleVw.isHidden = true
//            tableBgVw.isHidden = true
            noNotification(isHidden: true, text: "")
        }
        else{
//            noDataFoundLbl.isHidden = true
//            noDataFoundLbl.text = ""
//            feedListTbleVw.isHidden = false
//            tableBgVw.isHidden = false
        }
        tblNotication.reloadData()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setVSViewShadow(radius: 10, color: .black, view: self.btnBack, opacity: 0.12)
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
//            if arrNotificationresult.count > 0{
//                indexOfPageToRequest += 10
//                let data = String(indexOfPageToRequest)
//                loadApi(offset: data)
//                print(data)
//            }else{
//                noNotification(isHidden: true, text: "")
//            }
//        }
//    }
    
    //"Your session begins in 3 hours, will you still be attending your session?" ---  previously it was
    func performAttendingAlert(id : String, bookingId: String, rescheduleCount: String){
        Helper.shared.showAlertWithCallback(buttonText: R.string.localizable.yes(), buttonText2: R.string.localizable.no(), title: R.string.localizable.notificationtitle(), message: "Your session begins soon, will you still be attending your " + sessionTitleStr + " session?", controller: AppObject.window?.rootViewController ?? UIViewController()) { [weak self] result in
            guard let self else{return}
            if result{
                self.hitApi(id: "\(id)")
                Helper.shared.showAlertWithCallback(buttonText:  R.string.localizable.view(), buttonText2: R.string.localizable.later() , title: R.string.localizable.viewpolicy(), message: R.string.localizable.viewLatePolicy(), controller: AppObject.window?.rootViewController ?? UIViewController()) { [weak self] result in
                        guard let self else{return}
                        if result{
                            print("Yes Clicked")
                            let vc = PrivacyPolicyVC.instance()
                            vc.type = R.string.localizable.latePolicy()
                            vc.isFromReschedule = true
                            vc.rescheduleCountStr = rescheduleCount
                            //vc.url = cancelPolicy
//                            vc.url = "https://techugoserver.info/pvtg_dev/late_fee.html" // for test
                            vc.url = "https://dharma.services/late_fee.html" // for live
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
    
    func hitApi(id : String){
        let param : [String:String] = ["user_id" : SaveToDefaults().getUserId() ?? "" , "session_id":id ]
        api_manager.POSTApi(attendingSession(), param: param, header: header()) { (json, err, statusCode) in
        }
    }
}

//MARK: - TABLE VIEW DELEGATE AND DATASOURCE
extension NotificationVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.notificationVM.model?.result?.count ?? 0
        return self.arrNotificationresult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.ident, for: indexPath) as? NotificationCell else {return UITableViewCell()}
        //cell.setData(data: self.notificationVM.model?.result?[indexPath.row])
        cell.setData(data: self.arrNotificationresult[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("\(indexPath.row)")
        
        bookigIdSTr = self.arrNotificationresult[indexPath.row].booking_id ?? ""
        sessionIdSTr = self.arrNotificationresult[indexPath.row].session_id ?? ""
        rescheduleCountSTr = self.arrNotificationresult[indexPath.row].reschedule_count ?? ""
        sessionTitleStr = self.arrNotificationresult[indexPath.row].name_of_listing ?? ""
        
        amountSTr = self.arrNotificationresult[indexPath.row].amount ?? ""
        paymentIdStr = self.arrNotificationresult[indexPath.row].payment_id ?? ""
        chargeIdSTr = self.arrNotificationresult[indexPath.row].charge_id ?? ""
        bookingDateSTr = self.arrNotificationresult[indexPath.row].booking_date ?? ""
        
        var sessionType = self.arrNotificationresult[indexPath.row].type ?? ""
        if(sessionType == "normal" || sessionType == "booking" || sessionType == "place" || sessionType == "welcome" || sessionType == "booking_reschedule" || sessionType == "refund"){
            print("No notification reminder")
        }else if(sessionType == "session_follow_up"){
            let vc = SessionDetailVC.instance()
                vc.controllerId = 0
                vc.bookingId = self.bookigIdSTr
                vc.sessionId = self.sessionIdSTr
                vc.rescheduleCountStr = self.rescheduleCountSTr
                self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            guard let userid = SaveToDefaults().getUserId() else {return}
            
            //self.notificationVM.getCoachNotificationListApi(user_id: userid, offset: offset)
            self.notificationVM.makeCheckSession(user_id: userid, session_id: sessionIdSTr, schedule_time_id: self.arrNotificationresult[indexPath.row].schedule_time_id ?? "", booking_id: bookigIdSTr)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if apiHit && self.arrNotificationresult.count != 0 && (self.arrNotificationresult.count) - 1 == indexPath.row{
            self.apiHit = false
            loadApi()
        }
        }
}

//MARK: - VIEW CONTROLLER EXTENSION
extension NotificationVC {
//    private func loadApi(offset: String) {
    
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
            //notificationListData += self.notificationVM.model?.result ?? [NotificationListResult]()
            
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
