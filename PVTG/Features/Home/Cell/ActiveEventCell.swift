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
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var vwCard: UIView!
    
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
               self.lblBookingId.text = bookingId
           }
           if let bookingDate = data.booking_date {
               let strDate = yyMMMddDate(date: bookingDate)
               self.lblDate.text = strDate
           }
           if let tkts = data.ticket {
               self.lblNoOfTickets.text = tkts
           }
           if let paid = data.paid_amount {
               self.lblFair.text = paid
           }
           if let sessionName = data.name_of_listing {
               self.lblPlace.text = sessionName
           }
           if let rating = data.rating {
               let noOfStar = Double(rating)
               self.vwrating.settings.totalStars = Int(ceil(noOfStar ?? 0.0))
               self.vwrating.rating = noOfStar ?? 0.0
           }
           if let place = data.city, let distance = data.distance {
               let value = Double(distance) ?? 0.0
               let doubleStr = String(format: "%.2f", value)
               let str = place + " (\(doubleStr) km away)"
               self.lblplaceWithDistance.text = str
           }

       }
    
    

}
