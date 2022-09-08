//
//  NotificationCell.swift
//  NPNGCoachApp
//
//  Created by Test Machine on 30/10/20.
//  Copyright © 2020 Techugo. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var imgNotificatiuon: UIImageView!
    @IBOutlet weak var lblHead: UILabel!
    @IBOutlet weak var lblDaysAgo: UILabel!
    @IBOutlet weak var vwSeperator: UIView!
    @IBOutlet weak var imgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgNotificationDesc: UIImageView!
    @IBOutlet weak var imgBottomconstraint: NSLayoutConstraint!
    @IBOutlet weak var lblnotificationMessage: UILabel!
    
    //MARK: - Properties
    static let ident = "NotificationCell"
    class func nib()->UINib {
        return UINib.init(nibName: NotificationCell.ident, bundle: nil)
    }
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imgNotificatiuon.image = #imageLiteral(resourceName: "group-6")
        self.imgNotificatiuon.contentMode = .scaleAspectFit
        setVSViewShadow(radius: 10, color: .black, view: self.imgNotificatiuon, opacity: 0.12)
    }
    
    //MARK: - SET DATA METHOD
    func setData(data: NotificationListResult?) {
        guard let data = data else{return}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date1 = UTCToLocal(date: data.added_on ?? "")
        if let date = dateFormatter.date(from: date1) {
            self.lblDaysAgo.text = date.timeAgoSinceDate()
        }
        if let title = data.title {
            self.lblHead.text = title
        }
        if let body = data.body {
            debugPrint(body)
            self.lblnotificationMessage.text = body
        }

        let img = data.image ?? ""
        loadImage(img, self.imgNotificationDesc, activity: nil, defaultImage: nil)
    }
}
