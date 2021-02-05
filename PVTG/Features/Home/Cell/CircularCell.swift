//
//  CircularCell.swift
//  PVTG
//
//  Created by Techugo on 05/02/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit

class CircularCell: UICollectionViewCell {

    @IBOutlet weak var titileLbl: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    //MARK:- Cell reuseIdentifier
         static let ident = "CircularCell"
         class func nib()-> UINib {
             return UINib.init(nibName: CircularCell.ident, bundle: nil)
         }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
