//
//  EventsViewController.swift
//  PVTG
//
//  Created by Test Machine on 22/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit

class EventsViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionHeightCons: NSLayoutConstraint!
    @IBOutlet weak var collectionVwLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var colectionVw: UICollectionView!{
        didSet {
            colectionVw.dataSource = self
            colectionVw.delegate = self
            colectionVw.register(ActiveEventCell.nib(), forCellWithReuseIdentifier: ActiveEventCell.ident)
        }
    }
    
    @IBOutlet weak var TblVwHistory: UITableView!{
        didSet {
            TblVwHistory.dataSource = self
            TblVwHistory.delegate = self
            TblVwHistory.register(HistoryCell.nib(), forCellReuseIdentifier: HistoryCell.ident)
        }
    }
    
    @IBOutlet weak var lblActiveEvent: UILabel!
    @IBOutlet weak var lblUndrLine1: UILabel!
    @IBOutlet weak var lblUndrLine2: UILabel!
    @IBOutlet weak var lblHistoryEvent: UILabel!
    @IBOutlet weak var lblNoSession: UILabel!
    
    //MARK: - Properties
    private var indexOfCellBeforeDragging = 0
    private var currentPage: Int = 0
    var vm = EventViewModel()
    var indexOfPageToRequest = 0
    var ispageEnabled = false
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadApi(offset: "0")
        self.setCollectionVw()
    }
}

//MARK: - COLLECTION VIEW DELEGATES AND DATASOURCE
extension EventsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vm.model?.result?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActiveEventCell.ident, for: indexPath) as? ActiveEventCell else { return UICollectionViewCell() }
        cell.setData(data: self.vm.model?.result?[indexPath.row])
        cell.mapClosure = {
              self.directions(lat: self.vm.model?.result?[indexPath.row].lat ?? "" ,long: self.vm.model?.result?[indexPath.row].long ?? "")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SessionDetailVC.instance()
        vc.controllerId = 1
        vc.screenFrom = "EventVC"
        vc.bookingId = self.vm.model?.result?[indexPath.row].booking_id ?? ""
        vc.sessionId = self.vm.model?.result?[indexPath.row].session_id ?? ""
        vc.rescheduleCountStr = self.vm.model?.result?[indexPath.row].reschedule_count ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - TABLE VIEW DELEGATES AND DATASOURCE
extension EventsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.model?.history?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.ident, for: indexPath) as? HistoryCell else { return UITableViewCell() }
        cell.selectedRate = {
            let vc = RateUsVC.instance()
            vc.sessionid = self.vm.model?.history?[indexPath.row].session_id ?? ""
            vc.bookingID = self.vm.model?.history?[indexPath.row].booking_id ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cell.selectedIndex = { tap in
           self.directions(lat: self.vm.model?.history?[indexPath.row].lat ?? "" ,long: self.vm.model?.history?[indexPath.row].long ?? "")
        }
        cell.setData(data: self.vm.model?.history?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SessionDetailVC.instance()
        vc.controllerId = 3
        vc.screenFrom = "EventVC"
        vc.isFromRescheduleNo = false
        vc.sessionStatus = self.vm.model?.history?[indexPath.row].status ?? ""
        vc.sessionId = self.vm.model?.history?[indexPath.row].session_id ?? ""
        vc.bookingId = self.vm.model?.history?[indexPath.row].booking_id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

//MARK: - VIEW CONTROLLER EXTENSION
extension EventsViewController {
        func setCollectionVw() {
            self.colectionVw.showsHorizontalScrollIndicator = false
            let floawLayout = UPCarouselFlowLayout()
            if UIDevice().userInterfaceIdiom == .phone {
                if UIScreen.main.bounds.size.height == 568 {
                    floawLayout.itemSize = CGSize(width: SCREEN_WIDTH-44, height: colectionVw.frame.size.height)
                }else{
                    floawLayout.itemSize = CGSize(width: SCREEN_WIDTH-44, height: colectionVw.frame.size.height)
                }
            }
            floawLayout.scrollDirection = .horizontal
            floawLayout.sideItemScale = 0.9
            floawLayout.sideItemAlpha = 0.9
            floawLayout.spacingMode = .fixed(spacing: 10)
            colectionVw.collectionViewLayout = floawLayout
        }
    
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let layout = self.colectionVw.collectionViewLayout as! UPCarouselFlowLayout
            let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
            let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
            currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
            self.view.updateConstraints()
            self.view.layoutIfNeeded()
            debugPrint(currentPage)
        }

        fileprivate var pageSize: CGSize {
            let layout = self.colectionVw.collectionViewLayout as! UPCarouselFlowLayout
            var pageSize = layout.itemSize
            if layout.scrollDirection == .horizontal {
                pageSize.width += layout.minimumLineSpacing
            } else {
                pageSize.height += layout.minimumLineSpacing
            }
            return pageSize
        }
    
    //MARK: - OPEN GOOGLE MAP APP
    func directions(lat : String , long : String) {
        // if GoogleMap installed
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(NSURL(string:
                                                "comgooglemaps://?saddr=&daddr=\(lat),\(long)&directionsmode=driving")! as URL, options: [:], completionHandler: nil)
        } else {
            // if GoogleMap App is not installed
            UIApplication.shared.open(NSURL(string:
                                                "https://maps.google.com/?q=@\(lat),\(long)")! as URL, options: [:], completionHandler: nil)
        }
    }
    //MARK: - PAGINATION
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != self.colectionVw{
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
                // increments the number of the page to request
                if self.vm.model?.history?.count ?? 0 > 0{
                    indexOfPageToRequest += 10
                    let data = String(indexOfPageToRequest)
                    loadApi(offset: data)
                    print(data)
                    
                }else{
                    lblNoSession.isHidden = true
                    lblNoSession.text = ""
                }
            }
        }
     }
    
    //MARK: - LOADING API
    private func loadApi(offset: String) {
        if let userid = SaveToDefaults().getUserId(), let lat = SaveToDefaults().getLatitude(), let lng = SaveToDefaults().getLongtitude() {
            self.vm.getActiveEventApi(user_id: userid, latitude: "\(lat)", longitude: "\(lng)", offset: offset)
            //self.vm.getHistoryEventApi(user_id: userid, latitude: "\(lat)", longitude: "\(lng)")
        }
    }
}

//MARK: - LOADING EVENTS DELEGATE
extension EventsViewController: LoadingEvents {
    func colecnreloaddata() {
        if self.vm.model?.result?.count ?? 0 == 0{
            self.lblActiveEvent.isHidden = true
            self.lblUndrLine1.isHidden = true
            self.collectionHeightCons.constant = 0
        } else {
    
            self.lblActiveEvent.isHidden = false
            self.lblUndrLine1.isHidden = false
             self.collectionHeightCons.constant = 440
        }
        
        if self.vm.model?.history?.count ?? 0 == 0 &&  self.vm.model?.result?.count ?? 0 == 0{
             self.lblNoSession.text = R.string.localizable.noSession()
             self.lblNoSession.isHidden = false
        }else{
             self.lblNoSession.text = ""
             self.lblNoSession.isHidden = true
        }
        
        if self.vm.model?.history?.count == 0 || self.vm.model?.history?.count == nil{
            self.lblHistoryEvent.isHidden = true
            self.lblUndrLine2.isHidden = true
        } else {
            self.lblHistoryEvent.isHidden = false
            self.lblUndrLine2.isHidden = false
        }
        
        let tableHeight = (self.vm.model?.history?.count ?? 0) * 225
        constraintHeight.constant = CGFloat(tableHeight + (self.vm.model?.history?.count ?? 0) * 70)
        self.updateViewConstraints()
        self.view.layoutSubviews()
        self.view.layoutIfNeeded()
        self.TblVwHistory.reloadData()
        self.colectionVw.reloadData()
    }
    
    func tblReloadData() {
    }
}


