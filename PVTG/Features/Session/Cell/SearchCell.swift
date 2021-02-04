//
//  SearchCell.swift
//  PVTG
//
//  Created by Test Machine on 30/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit

class SearchCell: UICollectionViewCell {
    @IBOutlet weak var searchCategorylbl: UILabel!
    
    @IBOutlet weak var vwContainCatgry: UIView!
    @IBOutlet weak var leadingConstarintVw: NSLayoutConstraint!
    @IBOutlet weak var traillingConstarintVw: NSLayoutConstraint!
    
    //MARK:- Cell reuseIdentifier
    static let ident = "SearchCell"
    class func nib()-> UINib {
        return UINib.init(nibName: SearchCell.ident, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setData(data: AllTimeResult?) {
        guard let data = data else {return}
        if let date = data.from_time {
                let strTime = conversioninampmFormat(inputDate: date)
                if strTime.components(separatedBy: ":")[1] == "00 AM" || strTime.components(separatedBy: ":")[1] == "00 PM"{
                    self.searchCategorylbl.text = strTime.components(separatedBy: ":")[0]+strTime.components(separatedBy: " ")[1].lowercased()
        }
    }
}
    
    func setSearchData(data: CategoryResult?) {
         guard let data = data else {return}
        if let name = data.category_name {
            self.searchCategorylbl.text = name
        }
    }
}
