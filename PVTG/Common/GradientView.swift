//
//  GradientView.swift
//  WishTree
//
//  Created by techugo on 27/12/17.
//  Copyright © 2017 techugo. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var startColor:   UIColor = UIColor.init(hexString: "#FBAA38") { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = UIColor.init(hexString: "#EE2F26") { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.85 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    
    override class var layerClass: AnyClass { return CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }
    
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.8)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.8)
        } else {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.8, y: 0)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.8, y: 1)
        }
    }
    
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    
    func updateColors() {
        gradientLayer.colors    = [startColor.cgColor, endColor.cgColor]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateLocations()
        updateColors()
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    static var purpleActionBtn : UIColor { get { UIColor(named: "PurpleActionBtn") ?? .purple}}
    static var greyActionBtn : UIColor { get { UIColor(named: "GreyActionBtn") ?? .gray}}
}

extension UIView {
    func setCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
}
   func setViewGradientBackgroundColor() {
            
            self.clipsToBounds = true
            let gradient: CAGradientLayer = CAGradientLayer()
            let colorTop =  UIColor.init(hexString: "#f78b4a").cgColor
            let colorBottom = UIColor.init(hexString: "#d03c56").cgColor
            
            gradient.colors = [colorTop, colorBottom]
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.frame = self.bounds
            self.layer.insertSublayer(gradient, at: 0)
        }
    func setShadowView()
    {
        self.layer.shadowColor = UIColor().coloWithHexString(hex: "#E0E0E0").cgColor
        self.layer.shadowOffset = CGSize(width: 5.0 ,height:5.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1
        self.layer.masksToBounds = false
    }
    
    func lightSetShadow(){
        self.layer.shadowColor = UIColor().coloWithHexString(hex: "#CACDCD").cgColor
        self.layer.shadowOffset = CGSize(width: 0.0 ,height:5.0)
        self.layer.shadowOpacity = 0.9
        self.layer.shadowRadius = 1
        self.layer.masksToBounds = false
    }
    
    func bottomSetShadow(){
        self.layer.shadowColor = UIColor().coloWithHexString(hex: "#CACDCD").cgColor
        self.layer.shadowOffset = CGSize(width: 0.0 ,height:8.0)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 1
        self.layer.masksToBounds = false
    }
}

extension UIImageView
{
    func roundCornersForAspectFit(radius: CGFloat)
    {
        if let image = self.image {
            
            //calculate drawingRect
            let boundsScale = self.bounds.size.width / self.bounds.size.height
            let imageScale = image.size.width / image.size.height
            
            var drawingRect: CGRect = self.bounds
            
            if boundsScale > imageScale {
                drawingRect.size.width =  drawingRect.size.height * imageScale
                drawingRect.origin.x = (self.bounds.size.width - drawingRect.size.width) / 2
            } else {
                drawingRect.size.height = drawingRect.size.width / imageScale
                drawingRect.origin.y = (self.bounds.size.height - drawingRect.size.height) / 2
            }
            let path = UIBezierPath(roundedRect: drawingRect, cornerRadius: radius)
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}

