//
//  NotificationCell.swift
//  NPNGCoachApp
//
//  Created by Test Machine on 30/10/20.
//  Copyright © 2020 Techugo. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    //MARK:- KIbOutlets
    @IBOutlet weak var imgNotificatiuon: UIImageView!
    @IBOutlet weak var lblHead: UILabel!
    @IBOutlet weak var lblDaysAgo: UILabel!
    @IBOutlet weak var vwSeperator: UIView!
    
    @IBOutlet weak var imgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgNotificationDesc: UIImageView!
    
    //MARK:-  Variables

    static let ident = "NotificationCell"
      class func nib()->UINib {
          return UINib.init(nibName: NotificationCell.ident, bundle: nil)
      }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imgNotificatiuon.image = #imageLiteral(resourceName: "group-6")
        self.imgNotificatiuon.contentMode = .scaleAspectFit
        setVSViewShadow(radius: 10, color: .black, view: self.imgNotificatiuon, opacity: 0.12)
    }

    func setData(data: NotificationListResult?) {
        guard let data = data else{return}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date1 = UTCToLocal(date: data.added_on ?? "")
        if let date = dateFormatter.date(from: date1) {
            self.lblDaysAgo.text = date.timeAgoSinceDate()
        }
        self.lblHead.text = data.body ?? ""
        let type = data.type ?? "normal"
        let img = data.image ?? ""
        loadImage(img, self.imgNotificationDesc, activity: nil, defaultImage: nil)
//        switch type{
//        case "normal".capitalized:
//        default:
//            print("nil")
//            break
//        }
    }
}
