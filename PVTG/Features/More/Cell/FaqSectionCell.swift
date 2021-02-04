//
//  FaqSectionCell.swift
//  IDeals
//
//  Created by Rishabh on 24/09/19.
//  Copyright © 2019 Techugo. All rights reserved.
//

import UIKit

class FaqSectionCell: UITableViewCell {

    @IBOutlet weak var lbl_Section: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func toSetSectionData(data: String){
            lbl_Section.text = data
        
    }
    
}
