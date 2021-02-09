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
        if let time1 = data.from_time, let toTime = data.to_time {
            let time1Str = convertTimeIntoAmPmFormat(inputDate: time1)
             let time2Str = convertTimeIntoAmPmFormat(inputDate: toTime)
            self.searchCategorylbl.text = "\(time1Str) - \(time2Str)"
        }
    }

    
    func setSearchData(data: CategoryResult?) {
         guard let data = data else {return}
        if let name = data.category_name {
            self.searchCategorylbl.text = name
        }
    }
}
