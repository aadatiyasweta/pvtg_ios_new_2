//
//  FaqSectionCell.swift
//  IDeals
//
//  Created by Rishabh on 24/09/19.
//  Copyright © 2019 Techugo. All rights reserved.
//

import UIKit

class FaqSectionCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var lbl_Section: UILabel!
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK: - METHOD TO SET DATA
    func toSetSectionData(data: String){
            lbl_Section.text = data
        
    }
    
}
