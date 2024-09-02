//
//  SearchCell.swift
//  PVTG
//
//  Created by Test Machine on 30/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit

class SearchCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var searchCategorylbl: UILabel!
    @IBOutlet weak var vwContainCatgry: UIView!
    @IBOutlet weak var leadingConstarintVw: NSLayoutConstraint!
    @IBOutlet weak var traillingConstarintVw: NSLayoutConstraint!
    
    //MARK: - CELL REUSEIDENTIFIER
    static let ident = "SearchCell"
    class func nib()-> UINib {
        return UINib.init(nibName: SearchCell.ident, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - SET DATA
    func setData(data: AllTimeResult?) {
        guard let data = data else {return}
        if let time1 = data.from_time, let toTime = data.to_time {
            let time1Str = changeDateFormatForReminder(date: time1, fromFormat: "HH:mm", toFormat: "hh:mm a", currentTimeZone: data.currenttimezone ?? "")
            let time2Str = changeDateFormatForReminder(date: toTime, fromFormat: "HH:mm", toFormat: "hh:mm a", currentTimeZone: data.currenttimezone ?? "")
            self.searchCategorylbl.text = "\(time1Str) - \(time2Str)"
        }
    }

    func setSearchData(data: CategoryResult?) {
         guard let data = data else {return}
        if let name = data.category_name {
            if data.total_session ?? "" == ""{
                self.searchCategorylbl.text = name
            }else{
                self.searchCategorylbl.text = "\(name) (\(data.total_session ?? ""))"
            }
        }
    }
}
