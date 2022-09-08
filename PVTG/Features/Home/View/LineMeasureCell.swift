//
//  LineMeasureCell.swift
//  PVTG
//
//  Created by Techugo on 13/08/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit

class LineMeasureCell: UICollectionViewCell {

    //MARK: - Cell reuseIdentifier
    static let ident = "LineMeasureCell"
    class func nib()-> UINib {
        return UINib.init(nibName: LineMeasureCell.ident, bundle: nil)
    }
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
