//
//  TextExt.swift
//  RAMP
//
//  Created by Net tech on 03/02/20.
//  Copyright © 2020 NetTechnocrats. All rights reserved.
//

import UIKit

extension UILabel {
    var adjustedWidth: CGFloat {
        let lbl : UILabel = UILabel(frame: CGRect(x: 0, y: 0 , width: CGFloat.greatestFiniteMagnitude  , height: self.frame.height))
        lbl.lineBreakMode = self.lineBreakMode
        lbl.numberOfLines = self.numberOfLines
        lbl.text = self.text
        lbl.font = self.font
        lbl.sizeToFit()
        return lbl.frame.width
    }
    var adjustedHeight: CGFloat {
        let lbl : UILabel = UILabel(frame: CGRect(x: 0, y: 0 , width: self.frame.height , height: CGFloat.greatestFiniteMagnitude))
        lbl.lineBreakMode = self.lineBreakMode
        lbl.numberOfLines = self.numberOfLines
        lbl.text = self.text
        lbl.font = self.font
        lbl.sizeToFit()
        return lbl.frame.height
    }
}

//extension UITextView {
//    var adjustedWidth: CGFloat {
//        let lbl : UILabel = UILabel(frame: CGRect(x: 0, y: 0 , width: CGFloat.greatestFiniteMagnitude, height: self.frame.width))
//        lbl.lineBreakMode = .byWordWrapping
//        lbl.numberOfLines = 0
//        lbl.text = text
//        lbl.font = font
//        lbl.sizeToFit()
//        return lbl.frame.width
//    }
//    var adjustedHeight: CGFloat {
//        let lbl : UILabel = UILabel(frame: CGRect(x: 0, y: 0 , width: self.frame.width, height:  CGFloat.greatestFiniteMagnitude))
//        lbl.lineBreakMode = .byWordWrapping
//        lbl.numberOfLines = 0
//        lbl.text = text
//        lbl.font = font
//        lbl.sizeToFit()
//        return lbl.frame.height
//    }
//}

extension UITextField {
    var adjustedWidth: CGFloat {
        let lbl : UILabel = UILabel(frame: CGRect(x: 0, y: 0 , width: CGFloat.greatestFiniteMagnitude, height: self.frame.width))
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        lbl.text = text
        lbl.font = font
        lbl.sizeToFit()
        return lbl.frame.width
    }
    var adjustedHeight: CGFloat {
        let lbl : UILabel = UILabel(frame: CGRect(x: 0, y: 0 , width: self.frame.width, height:  CGFloat.greatestFiniteMagnitude))
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        lbl.text = text
        lbl.font = font
        lbl.sizeToFit()
        return lbl.frame.height
    }
}
