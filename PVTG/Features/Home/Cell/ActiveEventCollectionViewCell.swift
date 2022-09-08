//
//  ActiveEventCollectionViewCell.swift
//  PVTG
//
//  Created by kashish on 08/02/22.
//  Copyright © 2022 ShubhamMacmini. All rights reserved.
//

import UIKit

class ActiveEventCollectionViewCell: UICollectionViewCell {
 
 //MARK: - Properties
 static let reusablIdentifier = "ActiveEventCollectionViewCell"
 
 //MARK: - Outlets
 @IBOutlet weak var activeEventLabel: UILabel!
 @IBOutlet weak var activeEventImageView: UIImageView!
 @IBOutlet weak var containerView: UIView!
 
 //MARK: -  LifeCycle
 override func awakeFromNib() {
  super.awakeFromNib()
  // Initialization code
 }
 
 override func layoutSubviews() {
  containerView.layer.cornerRadius = 12
  containerView.layer.masksToBounds = true
 }
 
//MARK: - METHOD TO CONFIGURE UI
 func configureUI(with items:String,imageName:String){
  activeEventLabel.text = items
  activeEventImageView.image = UIImage(named: imageName)
 }
}
