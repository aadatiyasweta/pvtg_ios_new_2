//
//  InterestCell.swift
//  PVTG
//
//  Created by Test Machine on 28/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit

class InterestCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var imginterest: UIImageView!
    @IBOutlet weak var vwInterest: UIView!
    
    //MARK: - Properties
    static let ident = "InterestCell"
    
    //MARK: - CELL IDENTIFIER
    class func nib()-> UINib {
        return UINib.init(nibName: InterestCell.ident, bundle: nil)
    }

    //MARK: - LIFECYCLE METHOD
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
