//
//  ProfileInterestCell.swift
//  PVTG
//
//  Created by Test Machine on 05/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit
import MarqueeLabel

class ProfileInterestCell: UICollectionViewCell {
    @IBOutlet weak var imgInterest: UIImageView!
    @IBOutlet weak var lblInterest: UILabel!
    @IBOutlet weak var vwContaininterest: UIView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var traillingconstarint: NSLayoutConstraint!
    
    //MARK:- Cell reuseIdentifier
      static let ident = "ProfileInterestCell"
      class func nib()-> UINib {
          return UINib.init(nibName: ProfileInterestCell.ident, bundle: nil)
      }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()
         vwContaininterest.layer.borderWidth = 0.7
               vwContaininterest.layer.borderColor = UIColor().coloWithHexString(hex: "#e2e2e2").cgColor
        
    }
    
    func setData(interest: Selected_category?) {
        guard let interest = interest else {return}
        if let img = interest.category_image {
            loadImage(img, self.imgInterest, activity: nil, defaultImage: nil)
        }
        if let name = interest.category_name {
            self.lblInterest.text = name
        }
    }
    
    func setMarquee(label:MarqueeLabel) {
                  label.type = .continuous
              label.speed = .duration(4.0)
              label.animationCurve = .linear
              label.fadeLength = 0.0
              label.leadingBuffer = 10.0
              label.trailingBuffer = 30.0
              label.restartLabel()
          }

}
