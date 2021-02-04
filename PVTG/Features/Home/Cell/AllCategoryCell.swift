//
//  AllCategoryCell.swift
//  PVTG
//
//  Created by Test Machine on 21/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit

class AllCategoryCell: UICollectionViewCell {
    @IBOutlet weak var vwContainInterest: UIView!
    
    @IBOutlet weak var imgInterest: UIImageView!
    
    @IBOutlet weak var vwLeadingConstrain: NSLayoutConstraint!
    @IBOutlet weak var lblInterest: UILabel!
    
    @IBOutlet weak var btnTapClose: UIButton!
    @IBOutlet weak var vwtraillingConstrain: NSLayoutConstraint!
    
    //MARK:- Cell reuseIdentifier
    static let ident = "AllCategoryCell"
    class func nib()-> UINib {
        return UINib.init(nibName: AllCategoryCell.ident, bundle: nil)
    }

    var closure: ((_ selectedIndex: Int)->()) = {_ in }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.vwContainInterest.border(width: 0.7, color: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1))
    }
    
    @IBAction func closetap(_ sender: UIButton) {
        self.closure(self.tag)
    }
    
    
}
