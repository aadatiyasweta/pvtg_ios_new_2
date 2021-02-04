//
//  InterCell.swift
//  PVTG
//
//  Created by Test Machine on 22/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit

class InterCell: FSPagerViewCell {
    
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var img: UIImageView!

    //MARK:- Cell reuseIdentifier
      static let ident = "InterCell"
      class func nib()-> UINib {
          return UINib.init(nibName: InterCell.ident, bundle: nil)
      }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
