//
//  CountryCodeCell.swift
//  NPNGUserApp
//
//  Created by Techugo on 11/08/20.
//  Copyright © 2020 Techugo. All rights reserved.
//

import UIKit

class CountryCodeCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var codeLbl: UILabel!
    static let ident = "CountryCodeCell"
    class func nib()->UINib {
        return UINib.init(nibName: CountryCodeCell.ident, bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
}
