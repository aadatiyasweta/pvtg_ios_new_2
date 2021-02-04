//
//  SearchLocationCell.swift
//  PVTG
//
//  Created by Test Machine on 07/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit

class SearchLocationCell: UITableViewCell {
    @IBOutlet weak var lblCityNmae: UILabel!
    
    //MARK:- Cell reuseIdentifier
      static let ident = "SearchLocationCell"
      class func nib()-> UINib {
          return UINib.init(nibName: SearchLocationCell.ident, bundle: nil)
      }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
