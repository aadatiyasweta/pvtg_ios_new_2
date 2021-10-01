//
//  OnboardingSecondCell.swift
//  PVTG
//
//  Created by Techugo on 08/09/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit

class OnboardingSecondCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    static let ident = "OnboardingSecondCell"
    class func nib()->UINib {
        return UINib.init(nibName: OnboardingSecondCell.ident, bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func bindRewardData(model : [RewardsModel]){
        print(model.count)
        self.titleLbl.text =  R.string.localizable.earnUseRewardss()
        if model.count == 2{
            self.iconImageView.image = #imageLiteral(resourceName: "group3-1")
            self.backgroundColor = #colorLiteral(red: 0.3772953153, green: 0.8521574736, blue: 0.7450372577, alpha: 1)
            let str1 = R.string.localizable.onbaordingFiftMsg("\(model[0].discount ?? "-")%",model[0].points ?? "" , model[1].discount ?? "", model[1].points ?? "")
            self.descLbl.text = str1
           
         }
    }
}
