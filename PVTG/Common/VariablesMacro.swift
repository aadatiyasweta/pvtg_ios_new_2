

import Foundation
import UIKit


let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let keyWindow  = UIApplication.shared.keyWindow

let themeColor = #colorLiteral(red: 0.1843137255, green: 0.5529411765, blue: 0.168627451, alpha: 1)
let boldTextColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
let lightTextColor = #colorLiteral(red: 0.631372549, green: 0.631372549, blue: 0.631372549, alpha: 1)
let seperatorColor = #colorLiteral(red: 0.8312992454, green: 0.8314195275, blue: 0.8312730193, alpha: 1)
let popupBackgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)
let notificationColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
let teamGredientColors = [#colorLiteral(red: 0.3607843137, green: 0.7568627451, blue: 0.337254902, alpha: 1) , #colorLiteral(red: 0.1843137255, green: 0.5529411765, blue: 0.168627451, alpha: 1)]
let notificationDescColor  = #colorLiteral(red: 0.06274509804, green: 0.5411764706, blue: 0.6941176471, alpha: 1)
let shortTimeFormat = "yyyy-MM-dd"
let longTimeFormat = "yyyy-MM-dd hh:mm:ss"
let longDateFormat = "yyyy-MM-dd hh:mm:ss a"
let TimeFormat = "yyyy-MM-dd hh:mm a"
let WholeDayFormat = "hh:mm:ss"
let widthFactor : CGFloat = 1
let heightFactor = SCREEN_HEIGHT/580.0
let appName = "Dharma"

enum Fonts:String {
    case regular = "Montserrat-Regular"
    case light = "Montserrat-Light"
    case bold = "Montserrat-Bold"
    case semiBold = "Montserrat-SemiBold"
    case medium = "Montserrat-Medium"
}



let trophyInString = "🏆"

extension String {
    func htmlToAttributed()->NSAttributedString? {
        
        guard let data = self.data(using: .utf8) else {return nil}
        let attributedString = try? NSMutableAttributedString.init(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html], documentAttributes: nil)
        attributedString?.addAttributes([NSAttributedString.Key.font:getFont(Fonts.regular.rawValue, 12)!], range: NSRange.init(location: 0, length: (attributedString?.length)!))
        return attributedString
    }
}


extension UILabel {
    var numberOfVisibleLines: Int {
        let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(self.font.pointSize))
        return rHeight / charSize
    }
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

class WidthHeightConstraint : NSLayoutConstraint{
    override func awakeFromNib() {
        super.awakeFromNib()
        self.constant = self.constant*widthFactor
    }

    
}
extension UITextField {
    func placeholderColor(color: UIColor) {
        let attributeString = [
            NSAttributedString.Key.foregroundColor: color.withAlphaComponent(0.6),
            NSAttributedString.Key.font: self.font!
            ] as [NSAttributedString.Key : Any]
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: attributeString)
    }
}


var bundleKey: UInt8 = 0

class AnyLanguageBundle: Bundle {
    
    override func localizedString(forKey key: String,
                                  value: String?,
                                  table tableName: String?) -> String {
        
        guard let path = objc_getAssociatedObject(self, &bundleKey) as? String,
              let bundle = Bundle(path: path) else {
            
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    
    class func setLanguage(_ language: String) {
        
        defer {
            
            object_setClass(Bundle.main, AnyLanguageBundle.self)
        }
        
        objc_setAssociatedObject(Bundle.main, &bundleKey,    Bundle.main.path(forResource: language, ofType: "lproj"), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
