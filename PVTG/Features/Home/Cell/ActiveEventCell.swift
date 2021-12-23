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
    
    @IBOutlet weak var mapBtn: UIButton!
    var mapClosure : ()->() = {}
    //MARK:- Cell reuseIdentifier
      static let ident = "ActiveEventCell"
      class func nib()-> UINib {
          return UINib.init(nibName: ActiveEventCell.ident, bundle: nil)
      }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(data: EventsResult?) {
           guard let data = data else {return}
           if let category = data.category_name {
               self.lblSessionName.text = category
           }
           if let bookingId = data.booking_id {
            self.lblBookingId.text = "\(R.string.localizable.bookingID()) : \(bookingId)"
           }
           if let bookingDate = data.booking_date {
               let strDate = changeDateFormatForReminder(date: bookingDate, fromFormat: "yyyy-MM-dd HH:mm", toFormat: "dd MMM yyyy hh:mm a")
               self.lblDate.text = strDate
           }
        if let tkts = data.ticket {
            if tkts == "1"{
                self.lblNoOfTickets.text = "\(tkts) \(R.string.localizable.ticket())"
            }
            else{
                self.lblNoOfTickets.text = "\(tkts) \(R.string.localizable.tickets())"
            }
            
        }
           if let paid = data.paid_amount {
               self.lblFair.text = "\(data.currency ?? "") \(paid)"
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

       }
    
    @IBAction func mapBtnTap(_ sender: UIButton) {
        self.mapClosure()
    }
    

}
