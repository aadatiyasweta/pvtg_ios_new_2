//
//  SessionCell.swift
//  PVTG
//
//  Created by Test Machine on 23/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit
import Cosmos

class SessionCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var lblYoganame: UILabel!
    @IBOutlet weak var lblPlaceName: UILabel!
    @IBOutlet weak var vwRating: CosmosView!
    @IBOutlet weak var lblFromLocation: UILabel!
    @IBOutlet weak var vwCard: UIView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sessionImg: UIImageView!
    
    @IBOutlet weak var followUpView: UIView!
    //MARK: - CELL REUSEIDENTIFIER
    static let ident = "SessionCell"
    class func nib()-> UINib {
        return UINib.init(nibName: SessionCell.ident, bundle: nil)
    }
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        followUpView.isHidden = true
    }
    
    override func layoutSubviews() {
    }
    
    //MARK: - METHOD TO SET DATE
    func setData(data: SearchResult?) {
        guard let data = data else {return}
        if let category = data.category_name {
            self.lblYoganame.text = category
        }
        if let sessionName = data.name_of_listing {
            self.lblPlaceName.text = sessionName
        }
        if let rating = data.rating {
            self.vwRating.rating = Double(rating)!
        }
        if let place = data.city, let distance = data.distance {
            let value = Double(distance) ?? 0.0
            let doubleStr = String(format: "%.2f", value)
            let str = place + " " + R.string.localizable.kmaway(doubleStr)
            self.lblFromLocation.text = str
        }
        if let sessionImg = data.session_image {
            loadImage(sessionImg, self.sessionImg, activity: nil, defaultImage: nil)
        }
    }
    
    //MARK: - METHOD TO SET HOME DATA
    func setHomeData(data: All_result?) {
           guard let data = data else {return}
           if let category = data.category_name {
               self.lblYoganame.text = category
           }
           if let sessionName = data.name_of_listing {
               self.lblPlaceName.text = sessionName
           }
           if let rating = data.rating {
               self.vwRating.rating = Double(rating)!
           }
           if let place = data.city, let distance = data.distance {
               let value = Double(distance) ?? 0.0
               let doubleStr = String(format: "%.2f", value)
               let str = place + " " + R.string.localizable.kmaway(doubleStr)
               self.lblFromLocation.text = str
           }
           if let sessionImg = data.session_image {
               loadImage(sessionImg, self.sessionImg, activity: nil, defaultImage: nil)
           }
       }
}
