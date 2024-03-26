//
//  UIColorExtension.swift
//  MeasureMyBicycle
//
//  Created by Net tech on 26/12/19.
//  Copyright © 2019 NetTechnocrats. All rights reserved.
//

import UIKit

typealias UniColor = UIColor

extension UIColor {
    static var PRIMARY_PINK  : UIColor { get { UIColor(named: "PRIMARY_PINK")! } }
    static var PRIMARY_BLUE  : UIColor { get { UIColor(named: "PRIMARY_BLUE")! } }
    static var BABY_BLUE     : UIColor {get { UIColor(named: "BABY_BLUE")! } }
    static var BG1      : UIColor { get { UIColor(named: "BG1")! } }
    static var BG2      : UIColor { get { UIColor(named: "BG2")! } }
    static var BG3      : UIColor { get { UIColor(named: "BG3")! } }
    static var BG4      : UIColor { get { UIColor(named: "BG4")! } }
    static var BG5      : UIColor { get { UIColor(named: "BG5")! } }
    static var TEXT1    : UIColor { get { UIColor(named: "TEXT1")! } }
    static var TEXT2    : UIColor { get { UIColor(named: "TEXT2")! } }
    static var TEXT3    : UIColor { get { UIColor(named: "TEXT3")! } }
    static var TEXT4    : UIColor { get { UIColor(named: "TEXT4")! } }
    static var TEXT5    : UIColor { get { UIColor(named: "TEXT5")! } }
}

//extension UniColor {
//    convenience init?(hexString: String) {
//        self.init(hexString: hexString, alpha: 1.0)
//    }
//    
//    convenience init?(hexString: String, alpha: Float) {
//        var hex = hexString
//        
//        if hex.hasPrefix("#") {
//            hex = String(hex[hex.index(after: hex.startIndex)...])
//        }
//        
//        guard let hexVal = Int(hex, radix: 16) else {
//            self.init()
//            return nil
//        }
//        
//        switch hex.count {
//        case 3: self.init(hex3: hexVal, alpha: alpha)
//        case 6: self.init(hex6: hexVal, alpha: alpha)
//        default: self.init()
//            return nil
//        }
//    }
//    
//    fileprivate convenience init?(hex3: Int, alpha: Float) {
//        self.init(
//            red:   CGFloat( ((hex3 & 0xF00) >> 8).duplicate4bits() ) / 255.0,
//            green: CGFloat( ((hex3 & 0x0F0) >> 4).duplicate4bits() ) / 255.0,
//            blue:  CGFloat( ((hex3 & 0x00F) >> 0).duplicate4bits() ) / 255.0,
//            alpha: CGFloat(alpha)
//        )
//    }
//    
//    fileprivate convenience init?(hex6: Int, alpha: Float) {
//        self.init(
//            red: CGFloat( (hex6 & 0xFF0000) >> 16 ) / 255.0,
//            green: CGFloat( (hex6 & 0x00FF00) >> 8 ) / 255.0,
//            blue:  CGFloat( (hex6 & 0x0000FF) >> 0 ) / 255.0, alpha: CGFloat(alpha)
//        )
//    }
//    
//    convenience init?(hex: Int) {
//        self.init(hex: hex, alpha: 1.0)
//    }
//    
//    convenience init?(hex: Int, alpha: Float) {
//        if (0x000000 ... 0xFFFFFF) ~= hex {
//            self.init(hex6: hex, alpha: alpha)
//        } else {
//            self.init()
//            return nil
//        }
//    }
//}

extension Int {
//    func toColor(alpha: Float = 1.0) -> UniColor? {
//        UniColor(hex: self, alpha: alpha)
//    }
}


private extension Int {
    func duplicate4bits() -> Int {
        return (self << 4) + self
    }
}

