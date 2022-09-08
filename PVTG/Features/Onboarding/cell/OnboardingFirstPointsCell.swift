//
//  OnboardingFirstPointsCell.swift
//  PVTG
//
//  Created by Techugo on 08/09/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit

class OnboardingFirstPointsCell: UICollectionViewCell {

    //MARK: - Outlets
    @IBOutlet weak var firstLoginLbl: UILabel!
    @IBOutlet weak var firstBookinglbl: UILabel!
    @IBOutlet weak var bookingLbl: UILabel!
    @IBOutlet weak var reviewRateLbl: UILabel!
    @IBOutlet weak var tokenNotificationLbl: UILabel!
    @IBOutlet weak var vendorCancelLbl: UILabel!
    
    //MARK: - Properties
    static let ident = "OnboardingFirstPointsCell"
    class func nib()->UINib {
        return UINib.init(nibName: OnboardingFirstPointsCell.ident, bundle: nil)
    }
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - METHOD TO BIND DATA
    func bindData(model : Point_accumulationModel?){
        guard let model = model else{return}
        self.firstLoginLbl.attributedText = AttriButedcolor(str1: R.string.localizable.firstLogin(), str2: " \(model.first_login_point ?? "") \(R.string.localizable.pts())")
        self.firstBookinglbl.attributedText = AttriButedcolor(str1: R.string.localizable.firstBooking(), str2: " \(model.first_booking_point ?? "") \(R.string.localizable.pts())")
        self.bookingLbl.attributedText = AttriButedcolor(str1: R.string.localizable.bookings(), str2: " \(model.bookings ?? "") \(R.string.localizable.pts())")
        self.reviewRateLbl.attributedText = AttriButedcolor(str1: R.string.localizable.reviewsRate(), str2: " \(model.review_rate ?? "") \(R.string.localizable.pts())")
        self.tokenNotificationLbl.attributedText = AttriButedcolor(str1: R.string.localizable.viewTokenNotification(), str2: " \(model.view_token_notification ?? "") \(R.string.localizable.pts())")
        self.vendorCancelLbl.attributedText = AttriButedcolor(str1: R.string.localizable.ifVendorCancelBookingPoints(), str2: " \(model.vendor_cancel_booking_points ?? "") \(R.string.localizable.pts())")
    }
}
