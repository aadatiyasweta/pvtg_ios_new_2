//
//  SessionCell.swift
//  PVTG
//
//  Created by Test Machine on 23/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit
import Cosmos

class SessionCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var lblYoganame: UILabel!
    @IBOutlet weak var lblPlaceName: UILabel!
    @IBOutlet weak var vwRating: CosmosView!
    @IBOutlet weak var lblFromLocation: UILabel!
    @IBOutlet weak var vwCard: UIView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sessionImg: UIImageView!
    @IBOutlet weak var followUpView: UIView!
    //MARK: - CELL REUSEIDENTIFIER
    static let ident = "SessionCell"
    let gradientLayer = CAGradientLayer()
    class func nib()-> UINib {
        return UINib.init(nibName: SessionCell.ident, bundle: nil)
    }
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        followUpView.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
//            self.gradientLayer.frame = (self.sessionImg.bounds)
//            let colorSet = [UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.0),
//                            UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)]
//            let location = [0.1, 0.5]
//            self.sessionImg.addGradient(with: self.gradientLayer, colorSet: colorSet, locations: location)
//        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.gradientLayer.frame = self.sessionImg.bounds
            self.gradientLayer.colors = [
                UIColor.white.withAlphaComponent(0.0).cgColor,
                UIColor.black.withAlphaComponent(0.5).cgColor
            ]
            self.gradientLayer.locations = [0.0, 1.0] // Smoothly from top to bottom
            self.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // Top-center
            self.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)   // Bottom-center
            self.sessionImg.layer.addSublayer(self.gradientLayer)
        }
       
    }
    
    //MARK: - METHOD TO SET DATE
    func setData(data: SearchResult?) {
        guard let data = data else {return}
        if let category = data.category_name {
            self.lblYoganame.text = category
        }
        if let sessionName = data.name_of_listing {
            self.lblPlaceName.text = sessionName
        }
        if let rating = data.rating {
            self.vwRating.rating = Double(rating)!
        }
        if let place = data.city, let distance = data.distance {
            let value = Double(distance) ?? 0.0
            let doubleStr = String(format: "%.2f", value)
            let str = place + " " + R.string.localizable.kmaway(doubleStr)
            self.lblFromLocation.text = str
        }
        if let sessionImg = data.session_image {
            loadImage(sessionImg, self.sessionImg, activity: nil, defaultImage: nil)
        }
    }
    
    //MARK: - METHOD TO SET HOME DATA
    func setHomeData(data: All_result?) {
           guard let data = data else {return}
           if let category = data.category_name {
               self.lblYoganame.text = category
           }
           if let sessionName = data.name_of_listing {
               self.lblPlaceName.text = sessionName
           }
           if let rating = data.rating {
               self.vwRating.rating = Double(rating)!
           }
           if let place = data.city, let distance = data.distance {
               let value = Double(distance) ?? 0.0
               let doubleStr = String(format: "%.2f", value)
               let str = place + " " + R.string.localizable.kmaway(doubleStr)
               self.lblFromLocation.text = str
           }
           if let sessionImg = data.session_image {
               loadImage(sessionImg, self.sessionImg, activity: nil, defaultImage: nil)
           }
       }
}
extension UIView {
    func addGradient(with layer: CAGradientLayer, gradientFrame: CGRect? = nil, colorSet: [UIColor],
                     locations: [Double], startEndPoints: (CGPoint, CGPoint)? = nil) {
        layer.frame = gradientFrame ?? self.bounds
        layer.frame.origin = .zero
        
        let layerColorSet = colorSet.map { $0.cgColor }
        let layerLocations = locations.map { $0 as NSNumber }
        
        layer.colors = layerColorSet
        layer.locations = layerLocations
        
        if let startEndPoints = startEndPoints {
            layer.startPoint = startEndPoints.0
            layer.endPoint = startEndPoints.1
        }
        self.layer.mask = layer
        self.layer.insertSublayer(layer, above: self.layer)
    }
}
