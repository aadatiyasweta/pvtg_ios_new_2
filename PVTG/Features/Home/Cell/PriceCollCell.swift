//
//  PriceCollCell.swift
//  PVTG
//
//  Created by Techugo on 16/08/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit

class PriceCollCell: UICollectionViewCell {

    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var priceView: UIView!
    
    //MARK:- Cell reuseIdentifier
    static let ident = "PriceCollCell"
    class func nib()-> UINib {
        return UINib.init(nibName: PriceCollCell.ident, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
