//
//  EventsViewController.swift
//  PVTG
//
//  Created by Test Machine on 22/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit

class EventsViewController: BaseViewController {
    
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
    
    //MARK:-  Variables
    private var indexOfCellBeforeDragging = 0
    private var currentPage: Int = 0
    var vm = EventViewModel()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.delegate = self
        self.setCollectionVw()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadApi()
    }
    
  
}

extension EventsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vm.model?.result?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActiveEventCell.ident, for: indexPath) as? ActiveEventCell else { return UICollectionViewCell() }
        cell.setData(data: self.vm.model?.result?[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SessionDetailVC.instance()
        vc.controllerId = 1
        vc.sessionId = self.vm.model?.result?[indexPath.row].session_id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension EventsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.model?.history?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.ident, for: indexPath) as? HistoryCell else { return UITableViewCell() }
        cell.selectedRate = {
            let vc = RateUsVC.instance()
            vc.sessionid = self.vm.model?.history?[indexPath.row].session_id ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cell.selectedIndex = { tap in
            self.directions()
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
        vc.sessionId = self.vm.model?.history?[indexPath.row].session_id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

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
            //self.setData(model: planArr[currentPage])
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
    
    //Open Google map App
    func directions() {
        // if GoogleMap installed
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.openURL(NSURL(string:
                "comgooglemaps://?saddr=&daddr=\(27.045),\(77.459)&directionsmode=driving")! as URL)

        } else {
            // if GoogleMap App is not installed
            UIApplication.shared.openURL(NSURL(string:
                "https://maps.google.com/?q=@\(27.045),\(77.459)")! as URL)
        }
        
    }
    
    //Loading API
    
    private func loadApi() {
        if let userid = SaveToDefaults().getUserId(), let lat = SaveToDefaults().getLatitude(), let lng = SaveToDefaults().getLongtitude() {
            self.vm.getActiveEventApi(user_id: userid, latitude: "\(lat)", longitude: "\(lng)")
            //self.vm.getHistoryEventApi(user_id: userid, latitude: "\(lat)", longitude: "\(lng)")
        }
    }
        
}

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
             self.lblNoSession.text = "No Session"
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
        if self.vm.model?.result?.count == 0 || self.vm.model?.result?.count == nil{
            self.lblNoSession.isHidden = false
           
            self.lblHistoryEvent.isHidden = true
            self.lblUndrLine2.isHidden = true
        } else {
            self.lblNoSession.isHidden = true
           
            self.lblHistoryEvent.isHidden = false
            self.lblUndrLine2.isHidden = false
        }

       
    }
    
    
}


