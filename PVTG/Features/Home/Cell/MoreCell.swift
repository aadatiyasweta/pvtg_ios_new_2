//
//  MoreCell.swift
//  PVTG
//
//  Created by Test Machine on 30/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit

class MoreCell: UITableViewCell {
    //MARK:- IBOutlets
    @IBOutlet weak var lblMore: UILabel!
    
    @IBOutlet weak var vwSeperator: UIView!
    
    //MARK:- Cell reuseIdentifier
    static let ident = "MoreCell"
    class func nib()-> UINib {
        return UINib.init(nibName: MoreCell.ident, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //SetData
    func setMoreOptions(options: String) {
        self.lblMore.text = options
    }
    
}
