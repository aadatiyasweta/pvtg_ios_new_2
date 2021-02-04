//
//  FaqSupport_TVC.swift
//  IDeals
//
//  Created by Rishabh on 30/08/19.
//  Copyright © 2019 Techugo. All rights reserved.
//

import UIKit

class FaqSupport_TVC: UITableViewCell {

    @IBOutlet weak var img_dropdown: UIImageView!
    @IBOutlet weak var vw_ContainCellInfo: UIView!
    @IBOutlet weak var lbl_question: UILabel!
    @IBOutlet weak var lbl_Answers: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        self.contentView.layoutIfNeeded()
        vw_ContainCellInfo.layer.cornerRadius = 20
        vw_ContainCellInfo.clipsToBounds = true
        vw_ContainCellInfo.setGradient(strColor1: "#00c78c", strColor2: "#03babb", roundedCornerRadius: 20)
        vw_ContainCellInfo.setShadowView()
    }
//    func toSetQuery(data: Faq){
//        if let question = data.question{
//            lbl_question.text = question
//        
//        }
//    }
}
