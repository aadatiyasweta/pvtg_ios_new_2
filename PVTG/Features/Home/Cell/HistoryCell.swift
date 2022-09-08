//
//  HistoryCell.swift
//  PVTG
//
//  Created by Test Machine on 05/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit
import Cosmos

class HistoryCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var lblYoganame: UILabel!
    @IBOutlet weak var lblPlaceName: UILabel!
    @IBOutlet weak var vwRating: CosmosView!
    @IBOutlet weak var lblFromLocation: UILabel!
    @IBOutlet weak var vwCard: UIView!
    @IBOutlet weak var lblBookingId: UILabel!
    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var lblNoOfTickets: UILabel!
    @IBOutlet weak var vw3: UIView!
    @IBOutlet weak var lblFair: UILabel!
    @IBOutlet weak var vwRated: CosmosView!
    @IBOutlet weak var btnRate: UIButton!
    @IBOutlet weak var vwContainYogaName: UIView!
    @IBOutlet weak var btnbigRate: UIButton!
    @IBOutlet weak var sessionImage: UIImageView!
    
    //MARK: - CELL REUSEIDENTIFIER
    static let ident = "HistoryCell"
    class func nib()-> UINib {
        return UINib.init(nibName: HistoryCell.ident, bundle: nil)
    }
    var selectedIndex: (_ tappedIndex: Int) -> Void = { _ in  }
    var selectedRate: (()->())?
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - METHOD TO SET DATA
    func setData(data: EventsResult?) {
        guard let data = data else {return}
        if let category = data.category_name {
            self.lblYoganame.text = category
        }
        
        if let bookingId = data.booking_id {
            self.lblBookingId.text = "\(R.string.localizable.bookingID()) : \(bookingId)"
        }
        
        if let bookingDate = data.booking_date {
            let strDate = yyMMMddDate(date: bookingDate)
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
            self.lblPlaceName.text = sessionName
        }
        
        if let rating = data.rating {
            let noOfStar = Double(rating)
            self.vwRating.rating = noOfStar ?? 0.0
        }
        
        if let userRating = data.user_rating {
            let noOfStar = Double(userRating)
            self.vwRated.rating = noOfStar ?? 0.0
            
            if userRating == "0.00" {
                btnbigRate.isHidden = false
                btnRate.isHidden = false
            } else {
                btnbigRate.isHidden = true
                btnRate.isHidden = true
            }
        }
        
        if let place = data.city, let distance = data.distance {
            let value = Double(distance) ?? 0.0
            let doubleStr = String(format: "%.2f", value)
            let str = place + " " + R.string.localizable.kmaway(doubleStr)
            self.lblFromLocation.text = str
        }
        if let img = data.session_image {
            loadImage(img, self.sessionImage, activity: nil, defaultImage: nil)
        }
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func btntapToRate(_ sender: UIButton) {
        selectedRate!()
    }
    
    @IBAction func btnToGoMapApp(_ sender: UIButton) {
        selectedIndex(sender.tag)
    }
}
