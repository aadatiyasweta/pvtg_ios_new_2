//
//  OnboardingSecondCell.swift
//  PVTG
//
//  Created by Techugo on 08/09/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit

class OnboardingSecondCell: UICollectionViewCell {

    //MARK: - Outlets
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    //MARK: - Properties
    static let ident = "OnboardingSecondCell"
    class func nib()->UINib {
        return UINib.init(nibName: OnboardingSecondCell.ident, bundle: nil)
    }
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - BIND DATA METHOD
    func bindRewardData(model : [RewardsModel]){
        print(model.count)
        self.titleLbl.text =  R.string.localizable.earnUseRewardss()
        if model.count == 2{
            self.iconImageView.image = #imageLiteral(resourceName: "group3-1")
            self.backgroundColor = #colorLiteral(red: 0.3772953153, green: 0.8521574736, blue: 0.7450372577, alpha: 1)
            var strArr = [String]()
            if model[0].discount ?? "" == ""{
                strArr.append("\(model[0].milstone ?? "")- \(R.string.localizable.freeService())= \(model[0].points ?? "") \(R.string.localizable.pts())")
            }else{
                strArr.append("\(model[0].milstone ?? "")- \(model[0].discount ?? "") \(R.string.localizable.discount().lowercased())= \(model[0].points ?? "") \(R.string.localizable.pts())")
            }
            if model[1].discount ?? "" == ""{
                strArr.append("\(model[1].milstone ?? "")- \(R.string.localizable.freeService())= \(model[1].points ?? "") \(R.string.localizable.pts())")
            }else{
                strArr.append("\(model[1].milstone ?? "")- \(model[1].discount ?? "") \(R.string.localizable.discount().lowercased())= \(model[1].points ?? "") \(R.string.localizable.pts())")
            }
            self.descLbl.text = strArr.joined(separator: "\n\n")
         }
    }
}
