//
//  OnboardingCell.swift
//  NPNGUserApp
//
//  Created by Techugo on 11/08/20.
//  Copyright © 2020 Techugo. All rights reserved.
//

import UIKit

class OnboardingCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var imgDetailView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblInfo: UILabel!
    
    //MARK: - Properties
    var playcall : ()->() = {}
    static let ident = "OnboardingCell"
    class func nib()->UINib {
        return UINib.init(nibName: OnboardingCell.ident, bundle: nil)
    }
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func videoPlayTap(_ sender: UIButton) {
        self.playcall()
    }
}
