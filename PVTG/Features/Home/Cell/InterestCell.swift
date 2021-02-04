//
//  InterestCell.swift
//  PVTG
//
//  Created by Test Machine on 28/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit

class InterestCell: UICollectionViewCell {
    @IBOutlet weak var imginterest: UIImageView!
    
    @IBOutlet weak var vwInterest: UIView!
    static let ident = "InterestCell"
    class func nib()-> UINib {
        return UINib.init(nibName: InterestCell.ident, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
