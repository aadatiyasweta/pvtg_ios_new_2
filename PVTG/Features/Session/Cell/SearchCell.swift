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
       // iiconImgVw.isHidden = true
    }
    
    //MARK: - SET DATA
    func setData(data: AllTimeResult?) {
        guard let data = data else {return}
        if let time1 = data.from_time, let toTime = data.to_time {
            // Slot times are in the session's time zone; show them in the user's own time
            let date = data.schedule_date ?? ""
            let tz = data.currenttimezone
            let startDay = sessionDateTimeInLocal(date: date, time: time1, timeZoneId: tz, toFormat: "yyyy-MM-dd")
            // Add the day when the local time falls on a different day than the one picked
            let startFormat = (startDay != nil && startDay != String(date.prefix(10))) ? "d MMM, hh:mm a" : "hh:mm a"
            let time1Str = sessionDateTimeInLocal(date: date, time: time1, timeZoneId: tz, toFormat: startFormat)
                ?? changeDateFormatForReminder(date: time1, fromFormat: "HH:mm", toFormat: "hh:mm a", currentTimeZone: "")
            let time2Str = sessionDateTimeInLocal(date: date, time: toTime, timeZoneId: tz, toFormat: "hh:mm a")
                ?? changeDateFormatForReminder(date: toTime, fromFormat: "HH:mm", toFormat: "hh:mm a", currentTimeZone: "")
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
