//
//  HomeAllCollectionViewCell.swift
//  PVTG
//
//  Created by Techugo on 16/01/25.
//  Copyright © 2025 ShubhamMacmini. All rights reserved.
//

import UIKit

class HomeAllCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellBgVw: UIView!
    
    @IBOutlet weak var allLbl: UILabel!
    
    //MARK: - CELL REUSEIDENTIFIER
    static let ident = "HomeAllCollectionViewCell"
    class func nib()-> UINib {
        return UINib.init(nibName: HomeAllCollectionViewCell.ident, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
