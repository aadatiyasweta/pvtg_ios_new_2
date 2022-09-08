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
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.removeBadgeSubview()
        self.notificationVM.delegate = self
        loadApi(offset: "0")
        self.tblNotication.register(NotificationCell.nib(), forCellReuseIdentifier: NotificationCell.ident)
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
}

//MARK: - TABLE VIEW DELEGATE AND DATASOURCE
extension NotificationVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationVM.model?.result?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.ident, for: indexPath) as? NotificationCell else {return UITableViewCell()}
        if self.notificationVM.model?.result?[indexPath.row].image != "" {
            cell.imgHeightConstraint.constant = 150
            cell.imgBottomconstraint.constant = 15
        } else {
            cell.imgHeightConstraint.constant = 0
            cell.imgBottomconstraint.constant = 0
        }
        cell.setData(data: self.notificationVM.model?.result?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("\(indexPath.row)")
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
    func updateList() {
        if self.notificationVM.model?.result?.count ?? 0 > 0 {
            self.lbvlNoNotification.text = ""
            
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
