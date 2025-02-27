//
//  InterCell.swift
//  PVTG
//
//  Created by Test Machine on 22/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit

class InterCell: FSPagerViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var bgview: UIView!
    //MARK: - CELL REUSEIDENTIFIER
    static let ident = "InterCell"
    class func nib()-> UINib {
        return UINib.init(nibName: InterCell.ident, bundle: nil)
    }
    
    //MARK: - LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //bgview.backgroundColor = .yellow
    }
    
}
