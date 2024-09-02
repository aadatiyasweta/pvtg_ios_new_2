//


import Foundation
import UIKit

import Photos
import AssetsLibrary
import HealthKit
import UserNotifications
import AVFoundation
import SDWebImage
import Reachability
import SwiftyJSON
import SVProgressHUD

let documentsURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
var downloadURL = try! FileManager().url(for: .documentDirectory,
                                         in: .userDomainMask,
                                         appropriateFor: nil,
                                         create: true)
let window = UIApplication.shared.keyWindow
let defaults = UserDefaults.standard
let rupee = "₹"
let fontName  = "Fonts-Reg"
let borderWidth : CGFloat = 1.0
let borderColor  : UIColor =  #colorLiteral(red: 0.06274509804, green: 0.5411764706, blue: 0.6941176471, alpha: 1)
let cornerRadius : CGFloat = 4.0
let date = NSDate()
var isAuthrized:HKAuthorizationStatus!
let dateFormatter = DateFormatter()

enum PackType : String{
    case text
    case phone
    case video
}

enum Consultation {
    case selfConsultation
    case familyConsultation
}

func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
    guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
        completion(false)
        return
    }
    guard #available(iOS 10, *) else {
        completion(UIApplication.shared.openURL(url))
        return
    }
    UIApplication.shared.open(url, options: [:], completionHandler: completion)
}

enum FileType:Int{
    case ImageType = 0
    case FileType = 1
}

var tableFooterView:UIView = {
    let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 50))
    view.backgroundColor = .clear
    let activity = UIActivityIndicatorView.init(frame: CGRect.init(x: SCREEN_WIDTH/2 - 20, y: 5, width: 40, height: 40))
    activity.color = themeColor
    activity.center = view.center
    activity.startAnimating()
    view.addSubview(activity)
    return view
}()

enum FontStyle{
    case Regular
    case SemiBold
    case Bold
    case Medium
    case Light
}

func heightForView(_ text: Any, font:UIFont, width:CGFloat) -> CGFloat {
    let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    let estimatedFrame = NSString(string: text as! String).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: font], context: nil)
    return estimatedFrame.size.height
}

func widthForView(_ text: Any, font:UIFont, width:CGFloat) -> CGFloat {
    let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    let estimatedFrame = NSString(string: text as! String).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: font], context: nil)
    return estimatedFrame.size.width
}

func applyShadowForView(_ view :UIView, shadowColor: CGColor, ShadowOffset: CGSize, shadowOpacity: Float, shadowRadius: CGFloat) {
    view.layer.shadowColor = shadowColor
    view.layer.shadowOffset = ShadowOffset
    view.layer.shadowOpacity = shadowOpacity
    view.layer.shadowRadius = shadowRadius
    view.layer.masksToBounds = false
}

func convertampmformattohourformat(inputDate: String)-> String {
    if inputDate.contains("am".uppercased())||inputDate.contains("pm".uppercased()){
        let dateAsString = inputDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "HH:mm:ss"
        let Date24 = dateFormatter.string(from: date!)
        debugPrint("24 hour formatted Date:",Date24)
        return Date24
    }
    return inputDate
}

func convertTimeIntoAmPmFormat(inputDate: String)-> String {
    let dateAsString = inputDate
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm"
    guard let date1 = dateFormatter.date(from: dateAsString) else { return "01:10" }
    dateFormatter.dateFormat = "h:mm a"
    let Date24 = dateFormatter.string(from: date1)
    debugPrint("24 hour formatted Date:",Date24)
    return Date24
}

func convertIntoHourFormatted(inputDate: Date)-> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-mm-dd"
    dateFormatter.dateFormat = "EEEE, MMMM d"
    let Date24 = dateFormatter.string(from: inputDate)
    debugPrint("24 hour formatted Date:",Date24)
    return Date24
}

func stringconvertIntoHourFormatted(inputDate: String)-> String {
    let dateAsString = inputDate
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-mm-dd"
    let date = dateFormatter.date(from: dateAsString)
    debugPrint("Date is \(String(describing: date))")
    dateFormatter.dateFormat = "EEEE, MMMM dd"
    let Date24 = dateFormatter.string(from: date ?? Date())
    debugPrint("24 hour formatted Date:",Date24)
    return Date24
}

func conversioninampmFormat(inputDate: String)-> String {
    let dateAsString = inputDate
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    let date = dateFormatter.date(from: dateAsString)
    dateFormatter.dateFormat = "h:mm a"
    let Date24 = dateFormatter.string(from: date!)
    debugPrint("12 hour formatted Date:",Date24)
    return Date24
}

func applyShadowonEveryWall(_ view :UIView) {
    view.layer.shadowColor = seperatorColor.cgColor
    view.layer.shadowOffset = CGSize(width: 8 , height: 8);
    view.layer.shadowOpacity = 1.0
    view.layer.shadowRadius = 8.0
    view.layer.masksToBounds = false
}

func applyShadow(view:UIView , radius:CGFloat) {
    view.clipsToBounds = false
    view.layer.shadowColor = UIColor.darkGray.cgColor
    view.layer.shadowOpacity = 0.6
    view.layer.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
    view.layer.shadowRadius = 2
    view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: radius).cgPath
}

func getFileType(_ url:String)->(Int? , String?){
    if let fileURL = URL.init(string: url){
        print("File Type----->>>>>>",fileURL,"\n\n\n\n")
        let array:[String]? = fileURL.lastPathComponent.components(separatedBy: ".")
        print("File Components----->>>>>>",array ?? "NIL","\n\n\n\n")
        if (array?.count)! > 1{
            if let type = array?[1]{
                if type == "JPG" || type == "jpg" || type == "PNG" || type == "png" || type == "JPEG" || type == "jpeg"{
                    return (FileType.ImageType.rawValue , fileURL.lastPathComponent)
                }else{
                    return (FileType.FileType.rawValue , fileURL.lastPathComponent)
                }
            }
        }
    }
    return (nil , nil)
}

func getFileType(_ url:URL)->(Int? , String?){
    print("File Type----->>>>>>",url,"\n\n\n\n")
    let array:[String]? = url.lastPathComponent.components(separatedBy: ".")
    print("File Components----->>>>>>",array ?? "NIL","\n\n\n\n")
    if let type = array?[1]{
        if type == "JPG" || type == "jpg" || type == "PNG" || type == "png" || type == "JPEG" || type == "jpeg"{
            return (FileType.ImageType.rawValue , url.lastPathComponent)
        }else{
            return (FileType.FileType.rawValue , url.lastPathComponent)
        }
    }
    return (nil , nil)
}

func getRectForImage(_ imageView:UIImageView)->CGRect?{
    let height = SCREEN_WIDTH * (imageView.frame.height) / (imageView.frame.width)
    return CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: height)
}

func showAlert(msg:String , title:String , sender:UIViewController){
    let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 64*widthFactor))
    view.backgroundColor = #colorLiteral(red: 1, green: 0.7939705253, blue: 0, alpha: 1)
    let lbl = UILabel.init(frame: CGRect.init(x: 16, y: 64*widthFactor-30*widthFactor, width: SCREEN_WIDTH-16, height: 30*widthFactor))
    lbl.font = getFont(Fonts.bold.rawValue, 12)!
    lbl.textAlignment = .center
    lbl.text = msg
    lbl.textColor = .white
    view.addSubview(lbl)
    sender.view.addSubview(view)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
        lbl.removeFromSuperview()
        view.removeFromSuperview()
    })
}

func showMesssgeWindow(msg:String){
    let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 64*widthFactor))
    view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    let lbl = UILabel.init(frame: CGRect.init(x: 16, y: 64*widthFactor-30*widthFactor, width: SCREEN_WIDTH-16, height: 30*widthFactor))
    lbl.font = getFont(Fonts.bold.rawValue, 12)!
    lbl.textAlignment = .center
    lbl.text = msg
    lbl.textColor = .white
    view.addSubview(lbl)
    window?.addSubview(view)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
        lbl.removeFromSuperview()
        view.removeFromSuperview()
    })
}

func showMesssgeJustBelowView(view: UIView, msg:String){
    let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 64*widthFactor))
    view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    let lbl = UILabel.init(frame: CGRect.init(x: 16, y: 64*widthFactor-30*widthFactor, width: SCREEN_WIDTH-16, height: 30*widthFactor))
    lbl.font = getFont(Fonts.bold.rawValue, 12)!
    lbl.textAlignment = .center
    lbl.text = msg
    lbl.textColor = .white
    view.addSubview(lbl)
    //window?.addSubview(view)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
        lbl.removeFromSuperview()
    })
}

func paddingTextfield(textfield: UITextField) {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textfield.frame.height))
    textfield.leftView = paddingView
    textfield.leftViewMode = UITextField.ViewMode.always
    textfield.layer.cornerRadius = 10
}

func drawLayerBelowView(_ view: UIView , color : UIColor) {
    let layer = CALayer()
    layer.frame = CGRect(x: CGFloat(0), y: CGFloat(view.frame.size.height - 1), width: CGFloat(view.frame.size.width), height: CGFloat(1.0))
    layer.backgroundColor = color.cgColor
    layer.name = "bottomLayer"
    view.layer.addSublayer(layer)
}

func setupGradientLayer(view:UIView , upperColor:UIColor, lowerColor:UIColor) {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    print(view.bounds)
    gradientLayer.colors = [upperColor.cgColor, lowerColor.cgColor]
    gradientLayer.locations = [0.23,0.92]
    if view.layer.sublayers != nil{
        if (view.layer.sublayers?.count)! > 0{
            //print("Layer Count--->>>",(view.layer.sublayers?.count)!)
            for layer in view.layer.sublayers!{
                layer.removeFromSuperlayer()
            }
        }
    }
    view.layer.addSublayer(gradientLayer)
}

func setupLayerHorizonatal(view : UIView , color : [UIColor]){
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
    gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
    view.layer.addSublayer(gradientLayer)
}

//MARK: - UIVIEW EXTENSION

extension UIView {
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.8
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    func removeBlurEffect() {
        let blurredEffectViews = self.subviews.filter{$0 is UIVisualEffectView}
        blurredEffectViews.forEach{ blurView in
            blurView.removeFromSuperview()
        }
    }
    func animShow(){
        self.center.y = UIScreen.main.bounds.height - 125
        self.isHidden = false
    }
    
    func animHide(){
        self.isHidden = true
        self.center.y += self.bounds.height
    }
    
    func addDashedBorder() {
        let color = UIColor().coloWithHexString(hex: "#ffffff").cgColor
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.cornerRadius = 0
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [3,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 0).cgPath
        self.layer.addSublayer(shapeLayer)
    }
    
    func horizontalGredient(_ colors:[UIColor]) {
        var cgColor = [CGColor]()
        let gradientLayer = CAGradientLayer()
        var updatedFrame = self.bounds
        updatedFrame.size.height += 20
        gradientLayer.frame = updatedFrame
        for val in colors{
            cgColor.append(val.cgColor)
        }
        gradientLayer.colors = cgColor
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let imageView = UIImageView.init(frame: self.frame)
        self.addSubview(imageView)
        imageView.image = image
    }
}

func sethorizontalGradient(view : UIButton , colors : [UIColor]){
    var cgColor = [CGColor]()
    let gradientLayer = CAGradientLayer()
    var updatedFrame = view.bounds
    updatedFrame.size.height += 20
    gradientLayer.frame = updatedFrame
    for val in colors{
        cgColor.append(val.cgColor)
    }
    gradientLayer.colors = cgColor
    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
    gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
    UIGraphicsBeginImageContext(gradientLayer.bounds.size)
    gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    view.setBackgroundImage(image, for: .normal)
}

func setverticalGradient(view : UIView , colors : [UIColor]){
    var cgColor = [CGColor]()
    let gradientLayer = CAGradientLayer()
    var updatedFrame = view.bounds
    updatedFrame.size.height += 20
    gradientLayer.frame = updatedFrame
    for val in colors{
        cgColor.append(val.cgColor)
    }
    gradientLayer.colors = cgColor
    
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    UIGraphicsBeginImageContext(gradientLayer.bounds.size)
    gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
    UIGraphicsEndImageContext()
}

func setButtonBorder(button : UIButton , borderColor : UIColor , width : CGFloat = borderWidth ,  radius : CGFloat = cornerRadius){
    button.layer.borderWidth = width
    button.layer.borderColor = borderColor.cgColor
    button.layer.cornerRadius = cornerRadius
}

func getPoppinsFont(style:FontStyle , size:CGFloat)->UIFont?{
    switch style {
    case .Regular:
        return UIFont(name: "Raleway-Regular", size: size)
    case .Medium:
        return UIFont(name: "Raleway-Medium", size: size)
    case .SemiBold:
        return UIFont(name: "Raleway-SemiBold", size: size)
    case .Bold:
        return UIFont(name: "Raleway-Bold", size: size)
    case .Light:
        return UIFont(name: "Raleway-Light", size: size)
    }
}

let imageHeight = Int(0.61 * SCREEN_WIDTH)

func heightForViewForAttributedCondition(_ text: Any, fontSize:CGFloat, width:CGFloat,numberOfLines : Int,isAtrributedString : Bool) -> CGFloat{
    let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    
    let font = getFont(Fonts.regular.rawValue, fontSize)
    if isAtrributedString{
        let label:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.attributedText = text as? NSAttributedString
        label.sizeToFit()
        return label.frame.height
    }else{
        let estimatedFrame = NSString(string: text as! String).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: font!], context: nil)
        return estimatedFrame.size.height
    }
}

func convertDate(fromFormat : String = "HH:mm:ss", toFormat : String = "h:mm a", time : String)->String?{
    let formatter = DateFormatter()
    formatter.locale = Locale.current
    formatter.dateFormat = "HH:00:00"
    if let date = formatter.date(from: time){
        formatter.dateFormat = "h:mm a"
        let string = formatter.string(from: date)
        return string
    }
    else {
        formatter.dateFormat = fromFormat
        if  let date = formatter.date(from: time) {
            formatter.dateFormat = toFormat
            let string = formatter.string(from: date)
            return string
        }
    }
    return nil
}

func havePhotoAccess(completionHandler: @escaping (Bool)->Void) {
    let status = PHPhotoLibrary.authorizationStatus()
    print(status)
    if (status == PHAuthorizationStatus.authorized) {
        // Access has been granted.
        print("photo access allowed")
        DispatchQueue.main.async {
            completionHandler(true)
        }
    }
    else if (status == PHAuthorizationStatus.denied) {
        // Access has been denied.
        print("photo access denied")
        DispatchQueue.main.async {
            completionHandler(false)
        }
    }
    else if (status == PHAuthorizationStatus.notDetermined) {
        // Access has not been determined.
        PHPhotoLibrary.requestAuthorization({ (newStatus) in
            if (newStatus == PHAuthorizationStatus.authorized) {
                DispatchQueue.main.async {
                    completionHandler(true)
                }
            }
            else {
                DispatchQueue.main.async {
                    completionHandler(false)
                }
            }
        })
    }
}

func haveCameraAccess(completionHandler: @escaping (Bool)->Void) {
    if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized
    {
        // Already Authorized
        print("camera permission already authorised")
        DispatchQueue.main.async {
            completionHandler(true)
        }
    }
    else
    {
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted :Bool) -> Void in
            if granted == true
            {
                print("camera permission granted")
                DispatchQueue.main.async {
                    completionHandler(true)
                }
            }
            else
            {
                DispatchQueue.main.async {
                    completionHandler(false)
                }
            }
        });
    }
}

func getTimeStamp()-> Double{
    return Date().timeIntervalSince1970
}

func getWeekDay(date : Date)-> Int{
    let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
    let myComponents = myCalendar.components(.weekday, from: date)
    if let weekDay = myComponents.weekday{
        return weekDay
    }
    return 0
}

func getDayName(date : Date)-> String{
    let weekday = getWeekDay(date: date)
    switch weekday {
    case 1:
        return "Sun"
    case 2:
        return "Mon"
    case 3:
        return "Tue"
    case 4:
        return "Wed"
    case 5:
        return "Thu"
    case 6:
        return "Fri"
    case 7:
        return "Sat"
    default:
        return ""
    }
}
func getDayNameShort(date : Date)-> String{
    let weekday = getWeekDay(date: date)
    switch weekday {
    case 1:
        return "SU"
    case 2:
        return "MO"
    case 3:
        return "TU"
    case 4:
        return "WE"
    case 5:
        return "TH"
    case 6:
        return "FR"
    case 7:
        return "ST"
    default:
        return ""
    }
}

extension Date{
    func dayName()->String{
        let weekday = getWeekDay(date: self)
        switch weekday {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return ""
        }
    }
}

func endNotificationDate(days : Int,date : Date)-> Date{
    let interval = TimeInterval(60 * 60 * 24 * days)
    let newDate = date.addingTimeInterval(interval)
    return newDate as Date
}

func removeNotification(){
    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    } else {
        UIApplication.shared.cancelAllLocalNotifications()
    }
}

func getdateArryFromWeekdays(_ date: Date, onWeekdaysForNotify weekdays:[Int]) -> [Date]{
    var correctedDate: [Date] = [Date]()
    let now = Date()
    let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    let flags: NSCalendar.Unit = [NSCalendar.Unit.weekday, NSCalendar.Unit.weekdayOrdinal, NSCalendar.Unit.day]
    let dateComponents = (calendar as NSCalendar).components(flags, from: date)
    let weekday:Int = dateComponents.weekday!
    
    //no repeat
    if weekdays.isEmpty{
        //scheduling date is eariler than current date
        if date < now {
            //plus one day, otherwise the notification will be fired righton
            correctedDate.append((calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: 1, to: date, options:.matchNextTime)!)
        }
        else { //later
            correctedDate.append(date)
        }
        return correctedDate
    }
        //repeat
    else {
        let daysInWeek = 7
        correctedDate.removeAll(keepingCapacity: true)
        for wd in weekdays {
            
            var wdDate: Date!
            //schedule on next week
            if compare(weekday: wd, with: weekday) == .before {
                wdDate =  (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: wd+daysInWeek-weekday, to: date, options:.matchStrictly)!
            }
            else { //after
                wdDate =  (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: wd-weekday, to: date, options:.matchStrictly)!
            }
            
            //fix second component to 0
            wdDate = correctSecondComponent(date: wdDate, calendar: calendar)
            correctedDate.append(wdDate)
        }
        return correctedDate
    }
}

func formattedDaysInThisWeek(date : Date , arr : [Int]) -> [Date] {
    var arrDate = [Date]()
    let value = getWeekDay(date: date)
    print(value)
    print(arr)
    for i in 0..<arr.count{
        let date = endNotificationDate(days: arr[i], date: date)
        arrDate.append(date)
    }
    return arrDate
}

func correctSecondComponent(date: Date, calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian))->Date {
    let second = calendar.component(.second, from: date)
    let d = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.second, value: -second, to: date, options:.matchStrictly)!
    return d
}

enum weekdaysComparisonResult {
    case before
    case same
    case after
}

func compare(weekday w1: Int, with w2: Int) -> weekdaysComparisonResult{
    if w1 != 1 && w2 == 1 {return .before}
    else if w1 == w2 {return .same}
    else {return .after}
}

func viewIndexPathInTableView(_ cellItem: UIView, tableView tblView: UITableView) -> IndexPath? {
    let pointInTable: CGPoint = cellItem.convert(cellItem.bounds.origin, to: tblView)
    if let cellIndexPath = tblView.indexPathForRow(at: pointInTable){
        return cellIndexPath
    }
    return nil
}

func viewIndexPathInCollectionView(_ cellItem: UIView, collView: UICollectionView) -> IndexPath? {
    let pointInTable: CGPoint = cellItem.convert(cellItem.bounds.origin, to: collView)
    if let cellIndexPath = collView.indexPathForItem(at: pointInTable){
        return cellIndexPath
    }
    return nil
    
}

var player: AVAudioPlayer?
func playSound() {
    guard let url = Bundle.main.url(forResource: "ClickSound", withExtension: "mp3") else {
        print("error")
        return
    }
    do {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        try AVAudioSession.sharedInstance().setActive(true)
        player = try AVAudioPlayer(contentsOf: url)
        guard let player = player else { return }
        player.play()
    } catch let error {
        print(error.localizedDescription)
    }
}

func showOpenSettingAlert(sender : UIViewController){
    let alrt = UIAlertController(title: "Media Access Denied", message: "", preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ alert: UIAlertAction) -> Void in
        
    })
    let Cancel = UIAlertAction(title: "Setting", style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
//            UIApplication.shared.openURL(settingsUrl)
        }
    })
    alrt.addAction(ok)
    alrt.addAction(Cancel)
    sender.present(alrt, animated: true, completion: nil)
}

func changeDateFormatForReminder(date : String,fromFormat : String = "dd-MMMM-yyyy", toFormat : String = "yyyy-MM-dd", currentTimeZone:String)-> String{
    dateFormatter.dateFormat = fromFormat
    dateFormatter.timeZone = TimeZone(abbreviation: currentTimeZone)
    let date1 = dateFormatter.date(from: date)
    dateFormatter.timeZone = NSTimeZone.local
    dateFormatter.dateFormat = toFormat
    if date1 != nil{
        let str = dateFormatter.string(from: date1!)
        return str
    }
    return "Nil"
}

func weekDayarr(days : String)->[Int]{
    var weekDayArr = [Int]()
    let arryOfDays = days.components(separatedBy: ", ")
    for i in 0..<arryOfDays.count{
        let day = arryOfDays[i]
        switch day {
        case "Sun":
            weekDayArr.append(1)
        case "Mon":
            weekDayArr.append(2)
        case "Tue":
            weekDayArr.append(3)
        case "Wed":
            weekDayArr.append(4)
        case "Thu":
            weekDayArr.append(5)
        case "Fri":
            weekDayArr.append(6)
        case "Sat":
            weekDayArr.append(7)
        default:
            print("")
        }
    }
    return weekDayArr
}

func isValidPhone(_ phoneNumber: String) -> Bool {
    let mobileNumberPattern = "[123456789][0-9]{9}"
    let mobileNumberPred = NSPredicate(format: "SELF MATCHES %@", mobileNumberPattern)
    return mobileNumberPred.evaluate(with: phoneNumber)
}

func isValidName(Input:String) -> Bool {
    let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$")
    return predicateTest.evaluate(with: Input)
}

func getUrlOfImage(completion: @escaping (_ localIdentifier: URL?) -> Void) {
    let fetchOptions = PHFetchOptions()
    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    fetchOptions.fetchLimit = 1
    let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    
    if (fetchResult.firstObject != nil){
        let lastImageAsset: PHAsset = fetchResult.firstObject!
        lastImageAsset.requestContentEditingInput(with: nil, completionHandler: { (editing:PHContentEditingInput?, info) in
            if let contentEditing = editing{
                DispatchQueue.main.async {
                    completion(contentEditing.fullSizeImageURL)
                }
            }else{
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        })
    }
    else{
        completion(nil)
    }
}

func setOffTintSwictBtn(btn : UISwitch){
    btn.tintColor = lightTextColor
    btn.layer.cornerRadius = 16
    btn.backgroundColor = lightTextColor
}

func trackingScreenForGoogleAnalytics(screenName : String){
}

func isConnection()->Bool{
    let reachability = try! Reachability()
    if reachability.connection == .unavailable{
        return false
    }
    return true
    
}

//MARK: - DATE EXTENSION
extension Date{
      func dayAgo()->String{
        let weekday = getWeekDay(date: self)
        switch weekday {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return ""
        }
    }
    
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }

    func dateInString()->String{
        let dateFromatter = DateFormatter.init()
        dateFromatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFromatter.string(from: self)
    }
    
    func dateInStringWithAmPm()->String{
        let dateFromatter = DateFormatter.init()
        dateFromatter.dateFormat = "yyyy-MM-dd hh:mm a"
        return dateFromatter.string(from: self)
    }
    
    func dateInTime()->String{
        let dateFromatter = DateFormatter.init()
        dateFromatter.dateFormat = "hh:mm a"
        return dateFromatter.string(from: self)
    }
    
    func HHInTime()->String{
        let dateFromatter = DateFormatter.init()
        dateFromatter.dateFormat = "HH:mm"
        return dateFromatter.string(from: self)
    }
    
    func dateInMedium()->String{
        let dateFromatter = DateFormatter.init()
        dateFromatter.dateStyle = .medium
        return dateFromatter.string(from: self)
    }
    
    func HoursDate()->String?{
        let dateFromatter = DateFormatter.init()
        dateFromatter.dateFormat = "hh:mm a"
        return dateFromatter.string(from: self)
    }
}

func loadImage(_ url :String , _ imageView:UIImageView , activity:UIActivityIndicatorView? , defaultImage:UIImage?){
    if url == ""{
        imageView.contentMode = .scaleAspectFit
        imageView.image = defaultImage
    }else{
        imageView.sd_setImage(with: URL(string: url), placeholderImage: defaultImage, options: SDWebImageOptions.refreshCached)
    }
    print("IMAGE URL--->>>>" , url)
}

func loadProfilePic(_ url :String , _ imageView:UIImageView , activity:UIActivityIndicatorView? , name:String){
    print("IMAGE URL--->>>>" , url)
    imageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "name"), options: SDWebImageOptions.refreshCached)
}

func downloadImage(_ url :String , _ imageView:UIImageView , activity:UIActivityIndicatorView? , defaultImage:UIImage?){
    activity?.startAnimating()
    let urlStr = URL.init(string: url)
    let manager = SDWebImageDownloader.shared
    manager.downloadImage(with: urlStr, options: .highPriority, progress: nil) { (image:UIImage?, data:Data?, erroe:Error?, success:Bool) in
        if image != nil{
            activity?.stopAnimating()
            imageView.image = image
        }else{
            imageView.image = defaultImage
        }
        activity?.stopAnimating()
    }
}

func JSONtoString(_ data:[String:Any])->String?{
    do {
        let data = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        let string = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        return string as String?
    } catch  {
        print(error.localizedDescription)
    }
    return nil
}

func StringtoJSON(_ strin :String) {
    let data = strin.data(using: .utf8)
    do {
        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
        print(json)
    } catch  {
        print(error.localizedDescription)
    }
}

func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

//MARK: - VIEW CONTROLLER EXTENSION
extension UIViewController {
    func showInternetAlert(){
        let alert = UIAlertController.init(title: "Error", message: "It seems there is no Internet connection.", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
func isEmpty(_ text :String?)->Bool {
    if let value = text {
        let trimmed =  value.trimmingCharacters(in: .whitespaces)
        if trimmed.count > 0 {
            return false
        }
        if trimmed == "" {
            return true
        }
        return false
    }
    return true
}

enum DeviceType :String{
    case iPhone4S
    case iPhone5
    case iPhone6
    case iPhone7
    case iPhoneX
    case iPhoneMax
}

func currentUserDevice()->DeviceType {
    if SCREEN_HEIGHT == 480.0{
        return .iPhone4S
    }else if SCREEN_HEIGHT == 568.0 {
        return .iPhone5
    }else if SCREEN_HEIGHT == 667.0 {
        return .iPhone6
    }else if SCREEN_WIDTH == 375.0 && SCREEN_HEIGHT == 812.0 {
        return .iPhoneX
    }
    else  if SCREEN_WIDTH == 414.0 && SCREEN_HEIGHT == 896.0  {
        return .iPhoneMax
    }
    else{
        return .iPhone7
    }
}

func yyMMMddDate(date: String)->String?{
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = "yyyy-MM-dd"
    
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "dd MMM yyyy"
    
    let date = dateFormatterGet.date(from: date) ?? Date()
    print(dateFormatterPrint.string(from: date))
    return dateFormatterPrint.string(from: date)
}

func timeDifference(time1: String, time2: String)-> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mma"
    let date1 = formatter.date(from: time1)!
    let date2 = formatter.date(from: time2)!
    let elapsedTime = date2.timeIntervalSince(date1)
    let hours = floor(elapsedTime / 60 / 60)
    let minutes = floor((elapsedTime - (hours * 60 * 60)) / 60)
    debugPrint("\(Int(hours)) hr and \(Int(minutes)) min")
    return "\(Int(hours))"
}

func currentTime()-> String {
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .short
    debugPrint(dateFormatter.string(from: currentDate))
    return dateFormatter.string(from: currentDate)
}

//MARK: - STRING EXTENSION
extension String {
    func date()->Date?{
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = shortTimeFormat
        return dateFormatter.date(from: self)
    }

    func HHtime()->Date?{
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.date(from: self)
    }
    
    func yyMMddDate()->Date?{
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }
    
    func yyMMddThhmmssDate()->Date?{
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-ddThh:mm:ss"
        return dateFormatter.date(from: self)
    }
    
    func yyMMdd_HH_mm_a_Date()->Date?{
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = TimeFormat
        return dateFormatter.date(from: self)
    }
    
    func hhmmssDate()->Date?{
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "hh:mm:ss"
        return dateFormatter.date(from: self)
    }
    
    func fullDate()->Date?{
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = WholeDayFormat
        return dateFormatter.date(from: self)
    }
    
    func dateInTime()->String{
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: self.fullDate()!)
    }
    
    func dateInMediumFormat()->String{
        let date = self.fullDate()
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date!)
    }
    func dateInLongFormat()->Date{
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = TimeFormat
        return dateFormatter.date(from: self)!
    }
}

func randomString(length: Int) -> String {
    let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    var randomString = ""
    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    return randomString
}

func AttriButedText(str1 : String,color1:UIColor ,str2 : String,color2:UIColor) -> NSAttributedString{
    let attrStr1 = NSMutableAttributedString.init(string: str1)
    attrStr1.addAttribute(NSAttributedString.Key.foregroundColor, value: color1, range: NSMakeRange(0, attrStr1.length))
    attrStr1.addAttribute(NSAttributedString.Key.font, value: getPoppinsFont(style: .Regular, size: 11)!, range: NSMakeRange(0, attrStr1.length))
    let attrStr2 = NSMutableAttributedString.init(string: str2)
    attrStr2.addAttribute(NSAttributedString.Key.font, value: getPoppinsFont(style: .SemiBold, size: 11)!, range: NSMakeRange(0, attrStr2.length))
    attrStr1.append(attrStr2)
    return attrStr1
}

func AttriButedTextFirstBold(_ str1 : String, _ color1:UIColor, _ font1:UIFont , _ str2 : String, _ color2:UIColor , _ font2:UIFont) -> NSAttributedString{
    let attrStr1 = NSMutableAttributedString.init(string: str1)
    attrStr1.addAttribute(NSAttributedString.Key.foregroundColor, value: color1, range: NSMakeRange(0, attrStr1.length))
    attrStr1.addAttribute(NSAttributedString.Key.font, value: font1, range: NSMakeRange(0, attrStr1.length))
    let attrStr2 = NSMutableAttributedString.init(string: str2)
    
    attrStr2.addAttribute(NSAttributedString.Key.font, value: font2, range: NSMakeRange(0, attrStr2.length))
    attrStr1.append(attrStr2)
    return attrStr1
}

func AttriButedTextWithLastIsBold(str1 : String,color1:UIColor ,str2 : String,color2:UIColor) -> NSAttributedString{
    
    let attrStr1 = NSMutableAttributedString.init(string: str1)
    attrStr1.addAttribute(NSAttributedString.Key.foregroundColor, value: color1, range: NSMakeRange(0, attrStr1.length))
    attrStr1.addAttribute(NSAttributedString.Key.font, value: getFont(Fonts.regular.rawValue, 12)!, range: NSMakeRange(0, attrStr1.length))
    
    let attrStr2 = NSMutableAttributedString.init(string: str2)
    attrStr2.addAttribute(NSAttributedString.Key.foregroundColor, value: color2, range: NSMakeRange(0, attrStr2.length))
    attrStr2.addAttribute(NSAttributedString.Key.font, value: getFont(Fonts.regular.rawValue, 12)!, range: NSMakeRange(0, attrStr2.length))
    attrStr1.append(attrStr2)
    return attrStr1
}

func addRoundedLayer(radius:CGFloat , view :UIView) {
    view.clipsToBounds = false
    view.layer.shadowColor = UIColor.darkGray.cgColor
    view.layer.shadowOpacity = 0.6
    view.layer.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
    view.layer.shadowRadius = 2
    view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: radius).cgPath
}

func setRightBottomShadow(view : UIView,color:UIColor,opacity : Float){
    view.layer.shadowColor = color.cgColor
    view.layer.shadowOffset = CGSize.init(width: 0, height: 3)
    view.layer.shadowOpacity = opacity
    view.layer.shadowRadius = 1
    view.layer.masksToBounds = false
}

extension UIView{
    func shadow(radius:CGFloat , color:UIColor , _ opacity:Float) {
        self.clipsToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
        self.layer.shadowRadius = 2
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
    }
    func setGradient(strColor1:String,strColor2:String,roundedCornerRadius:CGFloat)
    {
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: self.frame.size)
        var layerToRemove = CAGradientLayer()
        
        if self.layer.sublayers != nil
        {
            for aLayer: CALayer in self.layer.sublayers! {
                if (aLayer is CAGradientLayer) {
                    layerToRemove = (aLayer as? CAGradientLayer)!
                    layerToRemove.removeFromSuperlayer()
                }
            }
        }
        gradient.colors = [UIColor().coloWithHexString(hex: strColor1).cgColor,UIColor().coloWithHexString(hex: strColor2).cgColor]
        let shape = CAShapeLayer()
        shape.lineWidth = 1
        let boundsLocal = CGRect(x: self.bounds.origin.x+1, y: self.bounds.origin.y+1, width: self.bounds.size.width-2, height: self.bounds.size.height-2)
        shape.path = UIBezierPath(roundedRect: boundsLocal, cornerRadius: roundedCornerRadius).cgPath
        
        shape.frame = gradient.bounds
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        
        gradient.mask = shape
        self.clipsToBounds = true
        self.layer.insertSublayer(gradient, at: 0)
        self.layer.borderColor = UIColor.clear.cgColor
    }
}

func addRoundedLightLayer(radius:CGFloat , view :UIView) {
    view.clipsToBounds = false
    view.layer.shadowColor = UIColor.lightGray.cgColor
    view.layer.shadowOpacity = 0.56
    view.layer.shadowOffset = CGSize.zero
    view.layer.shadowRadius = 2.6
    view.layer.cornerRadius = radius
}

extension UIView {
    func border(width:CGFloat , color:UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func roundCorner(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    func setShadowWithCorner(withOpacity: Float , shadowColor : CGColor, shadowRadius: CGFloat, shadowOffset : CGSize, borderWidth : CGFloat, borderColor: CGColor?, cornerRadius : CGFloat) {
        
        self.layer.shadowOpacity = withOpacity
        self.layer.shadowColor = shadowColor
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = shadowOffset
        self.layer.masksToBounds = false
        self.layer.cornerRadius = cornerRadius
    }
}

extension UITextField {
    func attributedPlaceHolder(color:UIColor) {
        if let text = self.placeholder {
            self.attributedPlaceholder = NSAttributedString(string: text,
                                                            attributes: [NSAttributedString.Key.foregroundColor: color])
        }
    }
}

func getFont(_ name:String, _ size:CGFloat)->UIFont? {
    return UIFont.init(name: name, size: size*widthFactor)
}

func addBottomShadow(view:UIView) {
    view.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
    view.layer.shadowRadius = 2.0
    view.layer.shadowColor = UIColor.lightGray.cgColor
    view.layer.shadowOpacity = 0.5
}

func getStringToDate(date : String , formater : String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = formater
    dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT+0:00") as TimeZone?
    let dateAsString = dateFormatter.date(from: date)
    return dateAsString ?? Date()
}

func getCurrentLocalDate()-> Date {
    var now = Date()
    var nowComponents = DateComponents()
    let calendar = Calendar.current
    nowComponents.year = Calendar.current.component(.year, from: now)
    nowComponents.month = Calendar.current.component(.month, from: now)
    nowComponents.day = Calendar.current.component(.day, from: now)
    nowComponents.hour = Calendar.current.component(.hour, from: now)
    nowComponents.minute = Calendar.current.component(.minute, from: now)
    nowComponents.second = Calendar.current.component(.second, from: now)
    nowComponents.timeZone = NSTimeZone(abbreviation: "GMT+0:00") as TimeZone?
    now = calendar.date(from: nowComponents)!
    return now as Date
}

func getMinutesDifferenceFromTwoDates(start: Date, end: Date) -> (hour: Int?, minute: Int?, second: Int?,day: Int?)
{
    let day = Calendar.current.dateComponents([.day], from: start, to: end).day
    let hour = Calendar.current.dateComponents([.hour], from: start, to: end).hour
    let minute = Calendar.current.dateComponents([.minute], from: start, to: end).minute
    let second = Calendar.current.dateComponents([.second], from: start, to: end).second
    
    return (hour: hour, minute: minute, second: second,day: day)
    
}

func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int , Int) {
    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
}

func isValidRefreshToken()->Bool{
    print("*********** isValidRefreshToken **************")
    let endtymstp = getTimeStamp()
    var startTimeStamp = SaveToDefaults().getTokenTimeStamp()
    
    if startTimeStamp == 0.0 || startTimeStamp == nil{
        startTimeStamp = getTimeStamp()
        SaveToDefaults().setTokenTimeStamp(startTimeStamp!)
    }
    let diffInTymStamp = endtymstp - startTimeStamp!
    print("diffInTymStamp : \(diffInTymStamp)")
    if let expires_in = SaveToDefaults().getExpiresIn(){
        let expires_in = Double (expires_in)
        if diffInTymStamp >= (expires_in - Double(100)){
            return false
        }
    }
    return true
}

extension UIImage {
    convenience init?(snapshotOf view: UIView) {
        guard let image = view.makeSnapshot(), let cgImage = image.cgImage else { return nil }
        self.init(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }
}

extension UIView {
    func makeSnapshot() -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: frame.size)
            return renderer.image { _ in drawHierarchy(in: bounds, afterScreenUpdates: true) }
        } else {
            return layer.makeSnapshot()
        }
    }
}

extension UIApplication {
    func getKeyWindow() -> UIWindow? {
        if #available(iOS 13, *) {
            return windows.first { $0.isKeyWindow }
        } else {
            return keyWindow
        }
    }
    func makeSnapshot() -> UIImage? { return getKeyWindow()?.layer.makeSnapshot() }
}

extension CALayer {
    func makeSnapshot() -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        render(in: context)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        return screenshot
    }
}

/*::---------::*/
func header()->[String:String]?{
    if let token = SaveToDefaults().getAccessToken(){
        print("Token -------->>>>>>",token)
        let header : [String: String] = [
            // "Content-Type" : "application/x-www-form-urlencoded",
//            "APPKEY": "\(token)" // old one
            "Appkey": "\(token)"
        ]
        print("Header :---: ",header)
        return header
    }
    return nil
}

extension UIViewController {
    
    func showOpenSettingAlert(title:String , message :String , completion:@escaping ()->Void){
        let alrt = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Cancel", style: .default, handler: {(_ alert: UIAlertAction) -> Void in
            completion()
        })
        let Cancel = UIAlertAction(title: "Open-Settings", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        })
        
        let attributedTitle = NSAttributedString.init(string: title, attributes: [NSAttributedString.Key.font:getFont(Fonts.bold.rawValue, 16)!])
        
        let attributedMessage = NSAttributedString.init(string: message, attributes: [NSAttributedString.Key.font:getFont(Fonts.regular.rawValue, 14)!])
        
        alrt.setValue(attributedTitle, forKey: "attributedTitle")
        alrt.setValue(attributedMessage, forKey: "attributedMessage")
        
        alrt.addAction(ok)
        alrt.addAction(Cancel)
        self.present(alrt, animated: true, completion: nil)
    }
    
    func showDeniedLocationlAlert(title:String , message :String){
        let alrt = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let Cancel = UIAlertAction(title: "Open-Settings", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        })
        
        let attributedTitle = NSAttributedString.init(string: title, attributes: [NSAttributedString.Key.font:getFont(Fonts.bold.rawValue, 16)!])
        
        let attributedMessage = NSAttributedString.init(string: message, attributes: [NSAttributedString.Key.font:getFont(Fonts.regular.rawValue, 14)!])
        
        alrt.setValue(attributedTitle, forKey: "attributedTitle")
        alrt.setValue(attributedMessage, forKey: "attributedMessage")
        
        alrt.addAction(Cancel)
        self.present(alrt, animated: true, completion: nil)
    }
    
    func showCantFindLocationlAlert(title:String , message :String , completion:@escaping (Bool)-> Void){
        let alrt = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let Cancel = UIAlertAction(title: "Retry", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            completion(true)
        })
        
        let selectList = UIAlertAction(title: "Select From List", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            completion(false)
        })
        
        let attributedTitle = NSAttributedString.init(string: title, attributes: [NSAttributedString.Key.font:getFont(Fonts.bold.rawValue, 16)!])
        
        let attributedMessage = NSAttributedString.init(string: message, attributes: [NSAttributedString.Key.font:getFont(Fonts.regular.rawValue, 14)!])
        
        alrt.setValue(attributedTitle, forKey: "attributedTitle")
        alrt.setValue(attributedMessage, forKey: "attributedMessage")
        
        alrt.addAction(selectList)
        alrt.addAction(Cancel)
        self.present(alrt, animated: true, completion: nil)
    }
    
    func maxLenghtOfTextField(text : UITextField, value : Int, range : NSRange,string: String) -> Bool{
        if range.length + range.location > text.text!.count{
            return false
        }
        let newLength = text.text!.count + string.count - range.length
        return  newLength <= value
    }
    
}

func UTCToLocal(date:String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let dt = dateFormatter.date(from: date)
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    print(dateFormatter.string(from: dt!))
    return dateFormatter.string(from: dt!)
}

func isDataSizeOverFlow(data:NSData , maxSize:CGFloat)->Bool{
    var size:CGFloat = CGFloat(data.length)
    size = (size / 1024.0 / 1024.0)
    if size <= maxSize{
        return false
    }
    return true
}

func setBorderWidtColorOofView(view : UIView , borderColor : UIColor , width : CGFloat , radius : CGFloat ){
    view.layer.borderWidth = width
    view.layer.borderColor = borderColor.cgColor
    view.layer.cornerRadius = radius
}

func setCellCardShadow(view : UIView){
    view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    view.layer.shadowOffset = CGSize(width: 0.0 ,height:0.0)
    view.layer.shadowOpacity = 0.1
    view.layer.shadowRadius = 4.0
    view.layer.masksToBounds = false
}

func setVSViewShadow(radius : CGFloat , color : UIColor , view : UIView , opacity : Float){
    view.clipsToBounds = false
    view.layer.shadowColor = color.cgColor
    view.layer.shadowOpacity = opacity
    view.layer.shadowOffset = CGSize.init(width: 0.0, height: 3.0)
    view.layer.shadowRadius = radius
    view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: radius).cgPath
}

func boldShadow(view: UIView, opacity: Float) {
    view.layer.shadowRadius = 0
    view.layer.shadowOffset = .zero
    view.layer.shadowOpacity = 0.2
    let shadowOffsetX: CGFloat = 50
    let shadowPath = UIBezierPath()
    shadowPath.move(to: CGPoint(x: 0, y: view.frame.height))
    shadowPath.addLine(to: CGPoint(x: view.frame.width, y: 0))
    shadowPath.addLine(to: CGPoint(x: view.frame.width + shadowOffsetX, y: 50))
    shadowPath.addLine(to: CGPoint(x: shadowOffsetX, y: 50))
    view.layer.shadowPath = shadowPath.cgPath
}

func setRightShadowWithOffset(view : UIView,color:UIColor,opacity : Float, width: CGFloat, height: CGFloat, offsetX: CGFloat, offsetY: CGFloat){
    view.layer.shadowColor = color.cgColor
    view.layer.shadowOffset = CGSize.init(width: width, height: height)
    view.layer.shadowOpacity = opacity
    view.layer.shadowRadius = 6
    view.layer.masksToBounds = false
    view.layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
}

func setRightShadow(view : UIView,color:UIColor,opacity : Float, width: CGFloat, height: CGFloat){
    view.layer.shadowColor = color.cgColor
    view.layer.shadowOffset = CGSize.init(width: width, height: height)
    view.layer.shadowOpacity = opacity
    view.layer.shadowRadius = 6
    view.layer.masksToBounds = false
}

func setCardViewShadow(radius : CGFloat , color : UIColor , view : UIView , opacity : Float){
    view.clipsToBounds = false
    view.layer.shadowColor = color.cgColor
    view.layer.shadowOpacity = opacity
    view.layer.shadowOffset = CGSize.init(width: 0.0, height: 10.0)
    view.layer.shadowRadius = radius
    view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: radius).cgPath
    view.layer.shouldRasterize = true
}

func setShadowView(_ vwMaster:UIView,color : UIColor){
    let ambientShadow = CAShapeLayer()
    let ambientShadowrMaskPath = UIBezierPath(roundedRect: vwMaster.bounds,
                                              byRoundingCorners: [.allCorners],
                                              cornerRadii: CGSize(width: 0, height: 0))
    ambientShadow.name = "ambientShadow"
    ambientShadow.frame = vwMaster.bounds
    ambientShadow.fillColor = UIColor.white.cgColor
    ambientShadow.path = ambientShadowrMaskPath.cgPath
    ambientShadow.shadowColor = color.cgColor
    ambientShadow.shadowRadius = 12
    ambientShadow.shadowOpacity = 1
    ambientShadow.shadowOffset = CGSize.init(width: 0, height: 10)
    ambientShadow.needsDisplayOnBoundsChange = true
    vwMaster.layer.insertSublayer(ambientShadow, at: 0)
}


func loginSignUpForgotShadow(cardView : UIView){
    cardView.clipsToBounds = false
    cardView.layer.shadowColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
    cardView.layer.shadowOpacity = 1
    cardView.layer.shadowOffset = CGSize.init(width: 0.0, height: 10.0)
    cardView.layer.shadowRadius = 10
    cardView.layer.shadowPath = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: 10).cgPath
}


func AttriButedLeaderBoard(str1 : String , str2 : String , str3:String,str4 : String , str5 : String , str6:String,str7 : String , str8 : String , str9:String , str10:String) -> NSAttributedString{
    let color1 = UIColor.black
    let color2 = themeColor
    
    let attrStr1 = NSMutableAttributedString.init(string: str1)
    attrStr1.addAttribute(NSAttributedString.Key.foregroundColor, value: color1, range: NSMakeRange(0, attrStr1.length))
    attrStr1.addAttribute(NSAttributedString.Key.font, value: getFont(Fonts.regular.rawValue, 12)!, range: NSMakeRange(0, attrStr1.length))
    
    let attrStr2 = NSMutableAttributedString.init(string: str2)
    attrStr2.addAttribute(NSAttributedString.Key.foregroundColor, value: color2, range: NSMakeRange(0, attrStr2.length))
    attrStr2.addAttribute(NSAttributedString.Key.font, value: getFont(Fonts.bold.rawValue, 12)!, range: NSMakeRange(0, attrStr2.length))
    attrStr1.append(attrStr2)
    
    let attrStr3 = NSMutableAttributedString.init(string: str3)
    attrStr3.addAttribute(NSAttributedString.Key.foregroundColor, value: color1, range: NSMakeRange(0, attrStr3.length))
    attrStr3.addAttribute(NSAttributedString.Key.font, value: getFont(Fonts.regular.rawValue, 12)!, range: NSMakeRange(0, attrStr3.length))
    attrStr1.append(attrStr3)
    
    let attrStr4 = NSMutableAttributedString.init(string: str4)
    attrStr4.addAttribute(NSAttributedString.Key.foregroundColor, value: color2, range: NSMakeRange(0, attrStr4.length))
    attrStr4.addAttribute(NSAttributedString.Key.font, value: getFont(Fonts.bold.rawValue, 12)!, range: NSMakeRange(0, attrStr4.length))
    attrStr1.append(attrStr4)
    
    let attrStr5 = NSMutableAttributedString.init(string: str5)
    attrStr5.addAttribute(NSAttributedString.Key.foregroundColor, value: color1, range: NSMakeRange(0, attrStr5.length))
    attrStr5.addAttribute(NSAttributedString.Key.font, value: getFont(Fonts.regular.rawValue, 12)!, range: NSMakeRange(0, attrStr5.length))
    attrStr1.append(attrStr5)
    
    
    let attrStr6 = NSMutableAttributedString.init(string: str6)
    attrStr6.addAttribute(NSAttributedString.Key.foregroundColor, value: color2, range: NSMakeRange(0, attrStr6.length))
    attrStr6.addAttribute(NSAttributedString.Key.font, value: getFont(Fonts.bold.rawValue, 12)!, range: NSMakeRange(0, attrStr6.length))
    attrStr1.append(attrStr6)
    
    let attrStr7 = NSMutableAttributedString.init(string: str7)
    attrStr7.addAttribute(NSAttributedString.Key.foregroundColor, value: color1, range: NSMakeRange(0, attrStr7.length))
    attrStr7.addAttribute(NSAttributedString.Key.font, value: getFont(Fonts.regular.rawValue, 12)!, range: NSMakeRange(0, attrStr7.length))
    attrStr1.append(attrStr7)
    
    
    let attrStr8 = NSMutableAttributedString.init(string: str8)
    attrStr8.addAttribute(NSAttributedString.Key.foregroundColor, value: color2, range: NSMakeRange(0, attrStr8.length))
    attrStr8.addAttribute(NSAttributedString.Key.font, value: getFont(Fonts.bold.rawValue, 12)!, range: NSMakeRange(0, attrStr8.length))
    attrStr1.append(attrStr8)
    
    let attrStr9 = NSMutableAttributedString.init(string: str9)
    attrStr9.addAttribute(NSAttributedString.Key.foregroundColor, value: color1, range: NSMakeRange(0, attrStr9.length))
    attrStr9.addAttribute(NSAttributedString.Key.font, value: getFont(Fonts.regular.rawValue, 12)!, range: NSMakeRange(0, attrStr9.length))
    attrStr1.append(attrStr9)
    
    let attrStr10 = NSMutableAttributedString.init(string: str10)
    attrStr10.addAttribute(NSAttributedString.Key.foregroundColor, value: color2, range: NSMakeRange(0, attrStr10.length))
    attrStr10.addAttribute(NSAttributedString.Key.font, value: getFont(Fonts.bold.rawValue, 12)!, range: NSMakeRange(0, attrStr10.length))
    attrStr1.append(attrStr10)
    return attrStr1
}

func directions(lat:Double? ,long:Double?) {
    if lat != nil && long != nil{
        if UIApplication.shared.canOpenURL(URL.init(string: "comgooglemaps://")!){
            UIApplication.shared.open(NSURL(string:
                                                "comgooglemaps://?saddr=&daddr=\(String(describing: lat!)),\(String(describing: long!))&directionsmode=driving")! as URL, options: [:], completionHandler: nil)
//            UIApplication.shared.openURL(NSURL(string:
//                "comgooglemaps://?saddr=&daddr=\(String(describing: lat!)),\(String(describing: long!))&directionsmode=driving")! as URL)
        }else{
            UIApplication.shared.open(NSURL(string:
                                                "https://www.google.co.in/maps/dir/?saddr=&daddr=\(String(describing: lat!)),\(String(describing: long!))")! as URL, options: [:], completionHandler: nil)
//            UIApplication.shared.openURL(NSURL(string:
//                "https://www.google.co.in/maps/dir/?saddr=&daddr=\(String(describing: lat!)),\(String(describing: long!))")! as URL)
        }
    }
}


extension UIScrollView {
    func shouldPaginate()->Bool {
        let currentOffset = self.contentOffset.y
        let maximumOffset = self.contentSize.height - self.frame.size.height
        if (maximumOffset - currentOffset <= 5) {
            return true
        }
        return false
    }
    func shouldPaginate1()->Bool {
        let currentOffset = self.contentOffset.y
        let maximumOffset = self.contentSize.height - self.frame.size.height
        if (maximumOffset - currentOffset <= 100) {
            return true
        }
        return false
    }
}

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
}

extension UIView {
    func circleCorner() {
        self.layer.cornerRadius = self.frame.height/2
    }
}


extension String {
    func underline() ->NSAttributedString{
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        var underlineAttributedString = NSMutableAttributedString(string: self, attributes: underlineAttribute)
        underlineAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: themeColor, range: NSMakeRange(0, underlineAttributedString.length))
        return  underlineAttributedString
    }
}

func labelFrame(width:CGFloat , font:UIFont , text:String , line:Int)->CGFloat{
    let label:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = line
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    label.sizeToFit()
    return label.frame.height
}

func labelLines(width:CGFloat , font:UIFont , text:String)->CGFloat{
    let label:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    label.sizeToFit()
    return label.frame.height
}

extension UIView {
    
    func showGradientColors(_ colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.bounds = self.bounds
        gradientLayer.anchorPoint = CGPoint.zero
        self.layer.addSublayer(gradientLayer)
    }
}
func years(from date: Date) -> Int {
    return Calendar.current.dateComponents([.year], from: date, to: Date()).year ?? 0
}
func months(from date: Date) -> Int {
    return Calendar.current.dateComponents([.month], from: date, to: Date()).month ?? 0
}

func weeks(from date: Date) -> Int {
    return Calendar.current.dateComponents([.weekOfMonth], from: date, to: Date()).weekOfMonth ?? 0
}

func days(from date: Date) -> Int {
    return Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
}

func hours(from date: Date) -> Int {
    return Calendar.current.dateComponents([.hour], from: date, to: Date()).hour ?? 0
}

func minutes(from date: Date) -> Int {
    return Calendar.current.dateComponents([.minute], from: date, to: Date()).minute ?? 0
}

func seconds(from date: Date) -> Int {
    return Calendar.current.dateComponents([.second], from: date, to: Date()).second ?? 0
}
func setRightCornerCircle(height : CGFloat,view : UIView,width : CGFloat){
    let path = UIBezierPath(roundedRect:view.bounds,
                            byRoundingCorners:[.topLeft, .bottomLeft],
                            cornerRadii: CGSize(width: width, height: height))
    
    let maskLayer = CAShapeLayer()
    maskLayer.path = path.cgPath
    view.layer.mask = maskLayer
}

extension CGPoint {
    static func subtractPoint(pointA: CGPoint?, withPoint pointB: CGPoint?) -> CGPoint {
        if let pointA = pointA, let pointB = pointB {
            let subtractedPoint = CGPoint(x: pointA.x - pointB.x, y: pointA.y - pointB.y)
            return subtractedPoint
        }
        else if let pointA = pointA {
            return pointA
        }
        else if let pointB = pointB {
            return CGPoint(x: pointB.x, y: pointB.y)
        }
        return CGPoint.zero
    }
}

func AttriButedcolor(str1 : String , str2 : String) -> NSAttributedString{
    let color1 = UIColor.white
    let color2 =  UIColor.white
    let attrStr1 = NSMutableAttributedString.init(string: str1)
    attrStr1.addAttribute(NSAttributedString.Key.foregroundColor, value: color1, range: NSMakeRange(0, attrStr1.length))
    attrStr1.addAttribute(NSAttributedString.Key.font, value: getFont(Fonts.regular.rawValue, 14)!, range: NSMakeRange(0, attrStr1.length))
    let attrStr2 = NSMutableAttributedString.init(string: str2)
    attrStr2.addAttribute(NSAttributedString.Key.foregroundColor, value: color2, range: NSMakeRange(0, attrStr2.length))
    attrStr2.addAttribute(NSAttributedString.Key.font, value: getFont(Fonts.semiBold.rawValue, 14)!, range: NSMakeRange(0, attrStr2.length))
    attrStr1.append(attrStr2)
    return attrStr1
}


extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}
extension Range where Bound == String.Index {
    var nsRange:NSRange {
        return NSRange(location: self.lowerBound.encodedOffset,
                       length: self.upperBound.encodedOffset -
                        self.lowerBound.encodedOffset)
    }
}

func isNtworkReachable() -> Bool {
    do{
        let currentReachabiltyStatus = try Reachability().connection
        if currentReachabiltyStatus.description == "No Connection" {
            return false
        } else {
            return true
        }
    }catch{
        return false
    }
}
func showAlert(strTitle:String)
{
    let alertViewController = UIAlertController(title: appName, message: strTitle, preferredStyle: .alert)
    alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
    appDelegate.window?.rootViewController?.present(alertViewController, animated: true, completion: nil)
}

func showAlertWithTitle(messageBody:String,controller:UIViewController) {
    DispatchQueue.main.async()
    {
        let alertController = UIAlertController(title: appName, message:
                                                    messageBody, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
        controller.present(alertController, animated: true, completion: nil)
    }
}

func elevateCardFromBottom(cardView : UIView){
    cardView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
    cardView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    cardView.layer.shadowOpacity = 1.0
    cardView.layer.shadowRadius = 0.0
    cardView.layer.masksToBounds = false
    cardView.layer.cornerRadius = 4.0
}
func blurEffect(_ view : UIView){
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
    let blurEffectView = UIVisualEffectView()
    blurEffectView.effect = blurEffect
    blurEffectView.frame = view.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    blurEffectView.alpha = 0.7
    view.addSubview(blurEffectView)
}
func decodeObject<Y: Decodable>(data: Data, completion: @escaping (Y) -> ()) {
    do {
        let model = try JSONDecoder().decode(Y.self, from: data)
        completion(model)
    } catch let jsonErr {
        print("failed to decode, \(jsonErr)")
    }
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func addshadow(top: Bool,
                   left: Bool,
                   bottom: Bool,
                   right: Bool,
                   shadowRadius: CGFloat = 3.0, shadowColor: CGColor, alpha: CGFloat) {
        self.alpha = alpha
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 1.0
        self.layer.shadowColor = shadowColor
        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = self.frame.width
        var viewHeight = self.frame.height
        
        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        if (!top) {
            y+=(shadowRadius+1)
        }
        if (!bottom) {
            viewHeight-=(shadowRadius+1)
        }
        if (!left) {
            x+=(shadowRadius+1)
        }
        if (!right) {
            viewWidth-=(shadowRadius+1)
        }
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y))
        // Move to the Bottom Left Corner, this will cover left edges
        /*
         |☐
         */
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        // Move to the Bottom Right Corner, this will cover bottom edge
        /*
         ☐
         -
         */
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        // Move to the Top Right Corner, this will cover right edge
        /*
         ☐|
         */
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        // Move back to the initial point, this will cover the top edge
        /*
         _
         ☐
         */
        path.close()
        self.layer.shadowPath = path.cgPath
    }
}

//MARK: - UICOLOR EXTENSION
extension UIColor
{
    func coloWithHexString(hex:String)->UIColor
    {
        let alpha:CGFloat = 1
        assert(hex[hex.startIndex] == "#", "Expected hex string of format #RRGGBB")
        
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 1 // skip #
        
        var rgb: UInt32 = 0
        scanner.scanHexInt32(&rgb)
        
        return UIColor(
            red: CGFloat((rgb & 0xFF0000) >> 16)/255.0,
            green: CGFloat((rgb & 0xFF00) >> 8)/255.0,
            blue: CGFloat((rgb & 0xFF) )/255.0,
            alpha: alpha)
    }
    
}

class CustomUITextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

extension Date {
    
    func timeAgoSinceDate() -> String {
        // From Time
        let fromDate = self
        
        // To Time
        let toDate = Date()
        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            return interval == 1 ? "\(interval)" + " " + "years ago" : "\(interval)" + " " + "years ago"
        }
        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            return interval == 1 ? "\(interval)" + " " + "months ago" : "\(interval)" + " " + "months ago"
        }
        
        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
            return interval == 1 ? "\(interval)" + " " + "days ago" : "\(interval)" + " " + "days ago"
        }
        
        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "hours ago" : "\(interval)" + " " + "hours ago"
        }
        
        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "minutes ago" : "\(interval)" + " " + "minutes ago"
        }
        return "a moment ago"
    }
}

//MARK: - IMAGE EXTENSION
extension UIImage {
    func toBase64() -> String? {
        guard let imageData = self.pngData() else { return nil }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
}
