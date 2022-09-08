//
//  MoreCell.swift
//  PVTG
//
//  Created by Test Machine on 30/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit

class MoreCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var lblMore: UILabel!
    @IBOutlet weak var vwSeperator: UIView!
    
    //MARK: - CELL REUSEIDENTIFIER
    static let ident = "MoreCell"
    class func nib()-> UINib {
        return UINib.init(nibName: MoreCell.ident, bundle: nil)
    }

    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK: - SET DATA METHOD
    func setMoreOptions(options: String) {
        self.lblMore.text = options
    }
    
}
