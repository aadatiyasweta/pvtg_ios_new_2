//
//  CategoryCell.swift
//  PVTG
//
//  Created by Test Machine on 23/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var imgcategory: UIImageView!
    @IBOutlet weak var vwcategory: UIView!
    @IBOutlet weak var trailingConstrainOuterview: NSLayoutConstraint!
    @IBOutlet weak var leadingConstrain: NSLayoutConstraint!
    
    //MARK: - CELL REUSE IDENTIFIER METHOD
    static let ident = "CategoryCell"
    class func nib()-> UINib {
        return UINib.init(nibName: CategoryCell.ident, bundle: nil)
    }
    
    //MARK: - LifeCycle Method
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        DispatchQueue.main.async {
            self.vwcategory.layer.borderColor = UIColor().coloWithHexString(hex: "#E2E2E2").cgColor
            self.vwcategory.layer.borderWidth = 1
        }
    }
    
    func setdata(data: Category?) {
        guard let data = data else {return}
        loadImage(data.image, imgcategory, activity: nil, defaultImage: nil)
        self.lblCategory.text = data.name
    }
}
