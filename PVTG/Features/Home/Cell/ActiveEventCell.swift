//
//  ActiveEventCell.swift
//  PVTG
//
//  Created by Test Machine on 05/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit
import Cosmos

class ActiveEventCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var lblSessionName: UILabel!
    @IBOutlet weak var lblBookingId: UILabel!
    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var lblNoOfTickets: UILabel!
    @IBOutlet weak var vw3: UIView!
    @IBOutlet weak var lblFair: UILabel!
    
    @IBOutlet weak var lblplaceWithDistance: UILabel!
    @IBOutlet weak var vwrating: CosmosView!
    @IBOutlet weak var lblPlace: UILabel!
    @IBOutlet weak var vwContainSession: UIView!
    
    @IBOutlet weak var sessionImage: UIImageView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var vwCard: UIView!
    @IBOutlet weak var activeEventCollectionView: UICollectionView!
    @IBOutlet weak var mapBtn: UIButton!
    
    @IBOutlet weak var followUpView: UIView!
    
    
    //MARK: - Properties
    var dictData:EventsResult?
    var mapClosure : ()->() = {}
    
    //MARK: - CELL REUSEIDENTIFIER
    static let ident = "ActiveEventCell"
    class func nib()-> UINib {
        return UINib.init(nibName: ActiveEventCell.ident, bundle: nil)
    }
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: "ActiveEventCollectionViewCell", bundle: nil)
        activeEventCollectionView?.register(nib, forCellWithReuseIdentifier: "ActiveEventCollectionViewCell")
    }
    
    //MARK: - METHOD TO SET DATA
    func setData(data: EventsResult?) {
        self.dictData = data
        activeEventCollectionView.delegate  = self
        activeEventCollectionView.dataSource = self
        guard let data = data else {return}
        if let category = data.category_name {
            self.lblSessionName.text = category
        }
        if let bookingId = data.booking_id {
            self.lblBookingId.text = "\(R.string.localizable.bookingID()) : \(bookingId)"
        }
        
        if let sessionName = data.name_of_listing {
            self.lblPlace.text = sessionName
        }
        if let rating = data.rating {
            let noOfStar = Double(rating)
            self.vwrating.rating = noOfStar ?? 0.0
        }
        if let place = data.city, let distance = data.distance {
            let value = Double(distance) ?? 0.0
            let doubleStr = String(format: "%.2f", value)
            let str = place + " " + R.string.localizable.kmaway(doubleStr)
            self.lblplaceWithDistance.text = str
        }
        if let img = data.session_image {
            loadImage(img, self.sessionImage, activity: nil, defaultImage: nil)
        }
        activeEventCollectionView.reloadData()
        
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func mapBtnTap(_ sender: UIButton) {
        self.mapClosure()
    }
    
}

//MARK: - COLLECTION VIEW DELEGATE
extension ActiveEventCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActiveEventCollectionViewCell", for: indexPath) as! ActiveEventCollectionViewCell
        if(indexPath.row == 0) {
            if let bookingDate = dictData?.booking_date {
                let strDate = changeDateFormatForReminder(date: bookingDate, fromFormat: "yyyy-MM-dd HH:mm", toFormat: "dd MMM yyyy hh:mm a", currentTimeZone: "")
                cell.configureUI(with: strDate, imageName:  "shape6Copy")
            }
        }else if(indexPath.row == 1){
            if let tkts = dictData?.ticket {
                if tkts == "1"{
                    cell.configureUI(with: "\(tkts) \(R.string.localizable.ticket())", imageName:  "shape7Copy")
                }
                else{
                    cell.configureUI(with: "\(tkts) \(R.string.localizable.tickets())", imageName:  "shape7Copy")
                }
            }
        }
        else if(indexPath.row == 2){
            if let paid = dictData?.paid_amount {
                cell.configureUI(with: "\(dictData?.currency ?? "") \(paid)", imageName:  "shape8Copy")
            }
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(indexPath.row == 0){
            if let bookingDate = dictData?.booking_date {
                let strDate = changeDateFormatForReminder(date: bookingDate, fromFormat: "yyyy-MM-dd HH:mm", toFormat: "dd MMM yyyy hh:mm a", currentTimeZone: "")
                let label = UILabel(frame: CGRect.zero)
                label.text = strDate
                label.sizeToFit()
                return CGSize(width:label.frame.size.width,height:25)
            }
        }else if(indexPath.row == 1){
            if let tkts = dictData?.ticket {
                var strTicket = ""
                if tkts == "1"{
                    strTicket = "\(tkts) \(R.string.localizable.ticket())"
                }
                else{
                    strTicket = "\(tkts) \(R.string.localizable.tickets())"
                }
                let label = UILabel(frame: CGRect.zero)
                label.text = strTicket
                label.sizeToFit()
                return CGSize(width:label.frame.size.width+35,height:25)
            }
        }else if(indexPath.row == 2){
            if let paid = dictData?.paid_amount {
                let label = UILabel(frame: CGRect.zero)
                label.text = paid
                label.sizeToFit()
                return CGSize(width:label.frame.size.width+60,height:25)
            }
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}


