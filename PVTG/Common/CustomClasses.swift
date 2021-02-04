//
//  CustomClasses.swift


import Foundation
import UIKit
import SVProgressHUD
import AVKit
import AVFoundation
class BorderButton:UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1.0
        self.layer.borderColor = themeColor.cgColor
    }
}


extension UILabel {
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    func setup() {
        let size = self.font.pointSize*widthFactor
        self.font = UIFont.init(name: self.font.fontName, size: size)
        if self.attributedText != nil {
            let str = self.attributedText
            self.attributedText = str
        }else{
             let str = self.text
             self.text = str
        }
    }
}


extension UITextField {
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    func setup() {
        let size = self.font!.pointSize*widthFactor
        self.font = UIFont.init(name: self.font!.fontName, size: size)
    }
    
    func isEmpty() ->Bool{
        guard var txxt = self.text else {return true}
        txxt = txxt.trimmingCharacters(in: .whitespaces)
        if txxt == "" || txxt.count == 0{
           return true
        }
        return false
    }
}

extension UITextView{
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    func setup() {
        let size = self.font!.pointSize*widthFactor
        self.font = UIFont.init(name: self.font!.fontName, size: size)
    }
    
    func isEmpty() ->Bool{
        guard var txxt = self.text else {return true}
        txxt = txxt.trimmingCharacters(in: .whitespaces)
        if txxt == "" || txxt.count == 0{
            return true
        }
        return false
    }
    
}

extension UIButton {
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    func setup() {
        let size = self.titleLabel!.font.pointSize*widthFactor
        let name = self.titleLabel!.font.fontName
        self.titleLabel?.font = UIFont.init(name: name, size: size)
    }
}


class OtpField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func deleteBackward() {
        NotificationCenter.default.post(name: Notification.Name("Back"), object: self)
        super.deleteBackward()
    }
    
}

class UnpasteField:UITextField{
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        print(action)
        if action == #selector(UIResponderStandardEditActions.paste(_:)){
            return false
        }
        if action == #selector(UIResponderStandardEditActions.cut(_:)){
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}



class BackVCFlowLayout: UICollectionViewFlowLayout {
    
    let baseHeight: CGFloat = 60.0
    var offsetX: CGFloat = 0 {
        willSet {
            let screenSize = UIScreen.main.bounds.size
            let cellHeight = baseHeight + 2.0 * (screenSize.height - 150.0) * newValue
            self.cellItemSize = CGSize(width: screenSize.width, height: cellHeight)
            self.invalidateLayout()
        }
    }
    var cellItemSize = CGSize(width: 1.0, height: 1.0)
    
    // MARK: Life Cycle methods
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func prepare() {
        self.scrollDirection = UICollectionView.ScrollDirection.vertical
        self.minimumLineSpacing = 0.0
        self.minimumInteritemSpacing = 0.0
        self.itemSize = self.cellItemSize
    }
}

class LanguageManager
{
    static let sharedInstance = LanguageManager()
    func LocalizedLanguage(key:String,languageCode:String)->String{
        var path = Bundle.main.path(forResource: languageCode, ofType: "lproj")
        path = (path != nil ? path:"")
        let languageBundle:Bundle!
        if(FileManager.default.fileExists(atPath: path!)){
            languageBundle = Bundle.init(path: path!)
            return languageBundle!.localizedString(forKey: key, value: "", table: nil)
        }
        return ""
    }
}


func LocalizeString(text : String , lang : String = SaveToDefaults().getAppLang() ?? "en")->String{
    return LanguageManager.sharedInstance.LocalizedLanguage(key: text, languageCode: SaveToDefaults().getAppLang() ?? "en")
}


/// Handles Convertion from instances of objects to JSON strings. Also helps with casting strings of JSON to Arrays or Dictionaries.
open class JSONSerializer {
    
    /**
    Errors that indicates failures of JSONSerialization
    - JsonIsNotDictionary:    -
    - JsonIsNotArray:            -
    - JsonIsNotValid:            -
    */
    public enum JSONSerializerError: Error {
        case jsonIsNotDictionary
        case jsonIsNotArray
        case jsonIsNotValid
    }
    
    //http://stackoverflow.com/questions/30480672/how-to-convert-a-json-string-to-a-dictionary
    /**
    Tries to convert a JSON string to a NSDictionary. NSDictionary can be easier to work with, and supports string bracket referencing. E.g. personDictionary["name"].
    - parameter jsonString:    JSON string to be converted to a NSDictionary.
    - throws: Throws error of type JSONSerializerError. Either JsonIsNotValid or JsonIsNotDictionary. JsonIsNotDictionary will typically be thrown if you try to parse an array of JSON objects.
    - returns: A NSDictionary representation of the JSON string.
    */
    public static func toDictionary(_ jsonString: String) throws -> NSDictionary {
        if let dictionary = try jsonToAnyObject(jsonString) as? NSDictionary {
            return dictionary
        } else {
            throw JSONSerializerError.jsonIsNotDictionary
        }
    }
    
    /**
    Tries to convert a JSON string to a NSArray. NSArrays can be iterated and each item in the array can be converted to a NSDictionary.
    - parameter jsonString:    The JSON string to be converted to an NSArray
    - throws: Throws error of type JSONSerializerError. Either JsonIsNotValid or JsonIsNotArray. JsonIsNotArray will typically be thrown if you try to parse a single JSON object.
    - returns: NSArray representation of the JSON objects.
    */
    public static func toArray(_ jsonString: String) throws -> NSArray {
        if let array = try jsonToAnyObject(jsonString) as? NSArray {
            return array
        } else {
            throw JSONSerializerError.jsonIsNotArray
        }
    }
    
    /**
    Tries to convert a JSON string to AnyObject. AnyObject can then be casted to either NSDictionary or NSArray.
    - parameter jsonString:    JSON string to be converted to AnyObject
    - throws: Throws error of type JSONSerializerError.
    - returns: Returns the JSON string as AnyObject
    */
    fileprivate static func jsonToAnyObject(_ jsonString: String) throws -> Any? {
        var any: Any?
        
        if let data = jsonString.data(using: String.Encoding.utf8) {
            do {
                any = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            }
            catch let error as NSError {
                let sError = String(describing: error)
                NSLog(sError)
                throw JSONSerializerError.jsonIsNotValid
            }
        }
        return any
    }

    /**
    Generates the JSON representation given any custom object of any custom class. Inherited properties will also be represented.
    - parameter object:    The instantiation of any custom class to be represented as JSON.
    - returns: A string JSON representation of the object.
    */
    public static func toJson(_ object: Any, prettify: Bool = false) -> String {
        var json = ""
        if (!(object is Array<Any>)) {
            json += "{"
        }
        let mirror = Mirror(reflecting: object)
        
        var children = [(label: String?, value: Any)]()
        
        if let mirrorChildrenCollection = AnyRandomAccessCollection(mirror.children) {
            children += mirrorChildrenCollection
        }
        else {
            let mirrorIndexCollection = AnyCollection(mirror.children)
            children += mirrorIndexCollection
        }
        
        var currentMirror = mirror
        while let superclassChildren = currentMirror.superclassMirror?.children {
            let randomCollection = AnyRandomAccessCollection(superclassChildren)!
            children += randomCollection
            currentMirror = currentMirror.superclassMirror!
        }
        
        var filteredChildren = [(label: String?, value: Any)]()
        
        for (optionalPropertyName, value) in children {

            if let optionalPropertyName = optionalPropertyName {

                if !optionalPropertyName.contains("notMapped_") {
                    filteredChildren.append((optionalPropertyName, value))
                }
                
            }
            else {
                filteredChildren.append((nil, value))
            }
        }
        
        var skip = false
        let size = filteredChildren.count
        var index = 0
        
        var first = true
        
        for (optionalPropertyName, value) in filteredChildren {
            skip = false
            
            let propertyName = optionalPropertyName
            let property = Mirror(reflecting: value)
            
            var handledValue = String()
            
            if propertyName != nil && propertyName == "some" && property.displayStyle == Mirror.DisplayStyle.struct {
                handledValue = toJson(value)
                skip = true
            }
            else if (value is Int ||
                     value is Int32 ||
                     value is Int64 ||
                     value is Double ||
                     value is Float ||
                     value is Bool) && property.displayStyle != Mirror.DisplayStyle.optional {
                handledValue = String(describing: value)
            }
            else if let array = value as? [Int?] {
                handledValue += "["
                for (index, value) in array.enumerated() {
                    handledValue += value != nil ? String(value!) : "null"
                    handledValue += (index < array.count-1 ? ", " : "")
                }
                handledValue += "]"
            }
            else if let array = value as? [Double?] {
                handledValue += "["
                for (index, value) in array.enumerated() {
                    handledValue += value != nil ? String(value!) : "null"
                    handledValue += (index < array.count-1 ? ", " : "")
                }
                handledValue += "]"
            }
            else if let array = value as? [Float?] {
                handledValue += "["
                for (index, value) in array.enumerated() {
                    handledValue += value != nil ? String(value!) : "null"
                    handledValue += (index < array.count-1 ? ", " : "")
                }
                handledValue += "]"
            }
            else if let array = value as? [Bool?] {
                handledValue += "["
                for (index, value) in array.enumerated() {
                    handledValue += value != nil ? String(value!) : "null"
                    handledValue += (index < array.count-1 ? ", " : "")
                }
                handledValue += "]"
            }
            else if let array = value as? [String?] {
                handledValue += "["
                for (index, value) in array.enumerated() {
                    handledValue += value != nil ? "\"\(value!)\"" : "null"
                    handledValue += (index < array.count-1 ? ", " : "")
                }
                handledValue += "]"
            }
            else if let array = value as? [String] {
                handledValue += "["
                for (index, value) in array.enumerated() {
                    handledValue += "\"\(value)\""
                    handledValue += (index < array.count-1 ? ", " : "")
                }
                handledValue += "]"
            }
            else if let array = value as? NSArray {
                handledValue += "["
                for (index, value) in array.enumerated() {
                    if !(value is Int) &&
                       !(value is Int32) &&
                       !(value is Int64) &&
                       !(value is Double) && !(value is Float) && !(value is Bool) && !(value is String) {
                        handledValue += toJson(value)
                    }
                    else {
                        handledValue += "\(value)"
                    }
                    handledValue += (index < array.count-1 ? ", " : "")
                }
                handledValue += "]"
            }
            else if property.displayStyle == Mirror.DisplayStyle.class ||
                property.displayStyle == Mirror.DisplayStyle.struct ||
                String(describing: value).contains("#") {
                handledValue = toJson(value)
            }
            else if property.displayStyle == Mirror.DisplayStyle.optional {
                let str = String(describing: value)
                if str != "nil" {
                    // Some optional values cannot be unpacked if type is "Any"
                    // We remove the "Optional(" and last ")" from the value by string manipulation
                    var d = String(str).dropFirst(9)
                    d = d.dropLast(1)
                    handledValue = String(d)
                } else {
                    handledValue = "null"
                }
            }
            else {
                handledValue = String(describing: value) != "nil" ? "\"\(value)\"" : "null"
            }
            
            if !skip {
                
                // if optional propertyName is populated we'll use it
                if let propertyName = propertyName {
                    json += "\"\(propertyName)\": \(handledValue)" + (index < size-1 ? ", " : "")
                }
                // if not then we have a member an array
                else {
                    // if it's the first member we need to prepend ]
                    if first {
                        json += "["
                        first = false
                    }
                    // if it's not the last we need a comma. if it is the last we need to close ]
                    json += "\(handledValue)" + (index < size-1 ? ", " : "]")
                }
                
            } else {
                json = "\(handledValue)" + (index < size-1 ? ", " : "")
            }
            
            index += 1
        }
        
        if !skip {
            if (!(object is Array<Any>)) {
                json += "}"
            }
        }
        
        if prettify {
           let jsonData = json.data(using: String.Encoding.utf8)!
           let jsonObject = try! JSONSerialization.jsonObject(with: jsonData, options: [])
           let prettyJsonData = try! JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
           json = NSString(data: prettyJsonData, encoding: String.Encoding.utf8.rawValue)! as String
        }
        
        return json
    }
    
    
}
class PasswordTextField: UITextField {
    
    override var isSecureTextEntry: Bool {
        didSet {
            if isFirstResponder {
                _ = becomeFirstResponder()
            }
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        
        let success = super.becomeFirstResponder()
        if isSecureTextEntry, let text = self.text {
            self.text?.removeAll()
            insertText(text)
        }
        return success
    }
}
@IBDesignable class PaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 0
    @IBInspectable var bottomInset: CGFloat = 0
    @IBInspectable var leftInset: CGFloat = 0
    @IBInspectable var rightInset: CGFloat = 0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}

class BaseVm : NSObject{
    
    func show(){
        if isConnection(){
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.clear)
        }
    }
    func dismiss(){
        SVProgressHUD.dismiss()
    }
    func showWithTouch(){
        if isConnection(){
            SVProgressHUD.show()
        }
    }
    func hideWithTouch(){
        SVProgressHUD.dismiss()
    }
}

class SimpleVideoView: UIView {
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var isLoop: Bool = false
    var videoFinshCallBack : () -> () = {}
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func configure(videoURL: URL) {
        let assest = AVAsset.init(url: videoURL)
        let playerItem = AVPlayerItem.init(asset: assest)
        player = AVPlayer.init(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = bounds
        playerLayer?.videoGravity = AVLayerVideoGravity.resize
        if let playerLayer = self.playerLayer {
            layer.addSublayer(playerLayer)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
    }
    
    func play() {
        if player?.timeControlStatus != AVPlayer.TimeControlStatus.playing {
            player?.play()
        }
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.pause()
        player?.seek(to: CMTime.zero)
    }
    
    @objc func reachTheEndOfTheVideo(_ notification: Notification) {
        self.videoFinshCallBack()
        if isLoop {
            player?.pause()
            player?.seek(to: CMTime.zero)
            player?.play()
        }
    }
}

