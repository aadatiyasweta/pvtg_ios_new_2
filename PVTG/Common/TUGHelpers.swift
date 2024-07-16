//
//  TUGHelpers.swift
//  Amlaakey
//
//  Created by Sunil  on 30/1/2020.
//  Copyright © 2020 Techugo Pvt Ltd. All rights reserved.
//

import UIKit
import Reachability

class TUGHelpers: NSObject {
    
    static var sharedInstance = TUGHelpers()
    
    var fromFollow = ""
    var gLatitude = 0.0
    var gLongitude = 0.0
    var screenSize:(height:Int,width:Int) = (0,0)
    var is_TechugoApi = false
    private override init() {
        
    }
    
    func getCompressedImage(image:UIImage,quality:CGFloat)->Data {
        return image.jpegData(compressionQuality: quality) ?? Data()
    }
    
    func isNull(_ text: String?) -> Bool {
        if ((text == nil) || (text == "nil") || (text == "<nil>") || (text == "") || (text?.isEqual(NSNull.self))!) {
            return true
        } else {
            return false
        }
    }
    
    class func isValidEmail(email:String?) -> Bool {
        guard email != nil else { return false }
        let regEx = "^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@([a-zA-Z0-9-]+[.]){1,2}[a-zA-Z]{2,10}"
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }
    
    class func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{6,}$")
        return passwordTest.evaluate(with: password)
    }
    
    class func isValidName(_ username: String) -> Bool {
        let regularExpressionText = "[a-zA-Z\\s]+"
        let regularExpression = NSPredicate(format:"SELF MATCHES %@", regularExpressionText)
        return regularExpression.evaluate(with: username)
    }
    
    class func isValidPostalCode(_ postalCode: String) -> Bool {
        let regularExpressionText = ".*[^A-Za-z0-9].*"
        let regularExpression = NSPredicate(format:"SELF MATCHES %@", regularExpressionText)
        return regularExpression.evaluate(with: postalCode)
    }
    
    class func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else { return false }
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: testStr)
    }
    class func createDottedLine(width: CGFloat, color: CGColor, view: UIView, strokeLength: NSNumber, gapLength: NSNumber) {
        let caShapeLayer = CAShapeLayer()
        caShapeLayer.strokeColor = color
        caShapeLayer.lineWidth = width
        caShapeLayer.lineDashPattern = [strokeLength, gapLength]
        let cgPath = CGMutablePath()
        let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: view.frame.width, y: 0)]
        cgPath.addLines(between: cgPoint)
        caShapeLayer.path = cgPath
        view.layer.addSublayer(caShapeLayer)
    }
    
    class func callNumber(phoneNumber:String) {
        let phoneNo =  RemoveWhiteSpace(aString: phoneNumber)
        DispatchQueue.main.async {
            if let phoneCallURL = URL(string: "tel://\(phoneNo)") {
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    class func RemoveWhiteSpace(aString:String) -> String {
        let s  =  aString.replacingOccurrences(of: " ", with: "")
        return s
    }
    
    
    func normalAlert(msg: String, view : UIView) {
        let alert = UIAlertController(title: appName, message: msg, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(dismiss)
        view.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func checkRating(rating: String) -> String {
        if rating != "R" && rating != "PG-13" && rating != "PG" && rating != "G" {
            return "NR"
        } else {
            return rating
        }
    }
    func addRemoveBorder(borderview:UIView,cornerradius:CGFloat,bordercolor:UIColor,borderwidth:CGFloat){
        borderview.layer.cornerRadius = cornerradius
        borderview.layer.borderColor = bordercolor.cgColor
        borderview.layer.borderWidth = borderwidth
    }
    
    func pathCurvedForView(givenView: UIView, curvedPercent:CGFloat) ->UIBezierPath {
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x:0, y:0))
        arrowPath.addLine(to: CGPoint(x:givenView.bounds.size.width, y:0))
        arrowPath.addLine(to: CGPoint(x:givenView.bounds.size.width, y:givenView.bounds.size.height - (givenView.bounds.size.height*curvedPercent)))
        arrowPath.addQuadCurve(to: CGPoint(x:0, y:givenView.bounds.size.height - (givenView.bounds.size.height*curvedPercent)), controlPoint: CGPoint(x:givenView.bounds.size.width/2, y:givenView.bounds.size.height ))
        arrowPath.addLine(to: CGPoint(x:0, y:0))
        arrowPath.close()
        
        return arrowPath
    }
    
    func applyCurvedPath(givenView: UIView,curvedPercent:CGFloat) {
        guard curvedPercent <= 1 && curvedPercent >= 0 else{
            return
        }
        let shapeLayer = CAShapeLayer(layer: givenView.layer)
        shapeLayer.path = self.pathCurvedForView(givenView: givenView,curvedPercent: curvedPercent).cgPath
        shapeLayer.frame = givenView.bounds
        shapeLayer.masksToBounds = true
        givenView.layer.mask = shapeLayer
    }
    
    
    
    func removeGradFromView(myView:UIView){
        var layerToRemove = CAGradientLayer()
        if myView.layer.sublayers != nil
        {
            for aLayer: CALayer in myView.layer.sublayers! {
                if (aLayer is CAGradientLayer) {
                    layerToRemove = (aLayer as? CAGradientLayer)!
                    layerToRemove.removeFromSuperlayer()
                }
            }
        }
    }
    
  
   
    
    func removeGradientFromBtn(myView:UIButton){
        var layerToRemove = CAGradientLayer()
        if myView.layer.sublayers != nil
        {
            for aLayer: CALayer in myView.layer.sublayers! {
                if (aLayer is CAGradientLayer) {
                    layerToRemove = (aLayer as? CAGradientLayer)!
                    layerToRemove.removeFromSuperlayer()
                }
            }
        }
    }
    
    func setTextFieldBorder(_ txtField: UITextField) {
        txtField.borderStyle = .none
        let border = CALayer()
        let borderwidth: CGFloat = 1.0
        border.borderColor = UIColor(red: 243 / 255.0, green: 243 / 255.0, blue: 244 / 255.0, alpha: 1.0).cgColor
        border.frame = CGRect(x: 0, y: txtField.frame.size.height - borderwidth, width: txtField.frame.size.width, height: txtField.frame.size.height)
        border.borderWidth = borderwidth
        txtField.layer.addSublayer(border)
        txtField.layer.masksToBounds = true
    }
    
    func getStartAndEndPosition(combination : NSMutableAttributedString, mainWord: String) -> NSRange {
        if combination.length != 0 {
            let startIndex = combination.length
            let endIndex = mainWord.count
            let range = NSRange(location: startIndex, length: endIndex)
            return range
        } else {
            return NSRange(location: 0, length: mainWord.count)
        }
    }
    
    func addShadowTo(view:UIView) {
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height:0.0 )
        view.layer.masksToBounds = false
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 10.0
        view.bringSubviewToFront(view)
    }
    
    func addShadowToView(view:UIView) {
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        view.layer.masksToBounds = false
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 2.0
        view.bringSubviewToFront(view)
    }
    func addShadowToCollView(view:UIView) {
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height:0.0 )
        view.layer.masksToBounds = false
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 8
        view.bringSubviewToFront(view)
    }
    
    func setTwoSideCornerRadius(view:UIView) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = view.frame
        rectShape.position = view.center
        rectShape.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 8, height: 8)).cgPath
        view.layer.mask = rectShape
    }
    
    func setTwoSideCornerRadiusONTop(view:UIView) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = view.frame
        rectShape.position = view.center
        rectShape.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 8, height: 8)).cgPath
        view.layer.mask = rectShape
    }
    
    func setTwoSideCornerRadiusRecordingView(view:UIView) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = view.frame
        rectShape.position = view.center
        rectShape.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        view.layer.mask = rectShape
    }
    func settopleftView(view:UIView) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = view.frame
        rectShape.position = view.center
        rectShape.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        view.layer.mask = rectShape
    }
    
    func getAppDelegateObject() -> AppDelegate {
        let appObj = UIApplication.shared.delegate as! AppDelegate
        return appObj
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
    
    
    func showAlertWithOKCallBack(messageBody:String,controller:UIViewController, completion: @escaping ( _ result:Bool) -> ()) {
        DispatchQueue.main.async()
        {
            let alertController = UIAlertController(title: appName, message:
                                                        messageBody, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: { action in
                completion(true)
            }))
            controller.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    class func showAlertView(_ alertTitle: String, alertMessage alertMsg: String, alertActionArr: [UIAlertAction], presentingView viewController: UIViewController) {
        let alert = UIAlertController(title: alertTitle, message: alertMsg, preferredStyle: .alert)
        for index in 0..<alertActionArr.count {
            alert.addAction(alertActionArr[index])
        }
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        viewController.present(alert, animated: true) { }
    }
    
    
    
    func hasNumbersOnly(txt: String) -> Bool {
        let txtNumb = Int(txt)
        if txtNumb != nil {
            return true
        } else {
            return false
        }
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func animateLogo(vwAnimation:UIView){
        vwAnimation.transform = CGAffineTransform(translationX: 0.0, y: -400)
        UIView.animate(withDuration: 1.0) { () -> Void in
            vwAnimation.transform = CGAffineTransform(translationX: 1, y: 1)
            
        }
    }
    
    func animateCountryText(vwAnimation:UIView){
        vwAnimation.transform = CGAffineTransform(translationX: 0.0, y: -10)
        UIView.animate(withDuration: 1.0) { () -> Void in
            vwAnimation.transform = CGAffineTransform(translationX: 1, y: 1)
            
        }
    }
    func animateCountryBottomToTopText(vwAnimation:UIView){
        vwAnimation.transform = CGAffineTransform(translationX: 0.0, y: 10)
        UIView.animate(withDuration: 1.0) { () -> Void in
            vwAnimation.transform = CGAffineTransform(translationX: 1, y: 1)
            
        }
    }
    func animateDropDownIndicator(dropDownView:UIView){
        UIView.animate(withDuration: 1, animations: {
            dropDownView.transform = CGAffineTransform(translationX: 1.0, y: -10.0)
            
        }) { (isSelect) in
            UIView.animateKeyframes(withDuration: 1, delay: 0.25, options: [.autoreverse,.repeat], animations: {
                dropDownView.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
            }, completion: nil)
        }
    }
    
    
    class func getTopMostViewController() -> UIViewController {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            // topController should now be your topmost view controller
            return topController
        }
        return UIViewController()
    }
    
    
    
    func decodeObject<Y: Decodable>(data: Data, completion: @escaping (Y) -> ()) {
        do {
            let model = try JSONDecoder().decode(Y.self, from: data)
            completion(model)
        } catch let jsonErr {
            print("failed to decode, \(jsonErr)")
        }
        
    }
    
    
    class func showAlertWithAction(title: String?, message: String?,cancelTitle:String, style: UIAlertController.Style, actionTitles:[String?], action:((UIAlertAction) -> Void)?) {
        
        showAlertWithActionWithCancel(title: title, message: message, style: style, actionTitles: actionTitles, showCancel: false, deleteTitle: nil, cancelTitle: cancelTitle, action: action)
    }
    
    class func showAlertWithActionWithCancel(title: String?, message: String?, style: UIAlertController.Style, actionTitles:[String?], showCancel:Bool, deleteTitle: String?, cancelTitle: String? , _ viewC: UIViewController? = nil, action:((UIAlertAction) -> Void)?) {
        
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        if deleteTitle != nil {
            let deleteAction = UIAlertAction(title: deleteTitle, style: .destructive, handler: action)
            alertController.addAction(deleteAction)
        }
        for (_, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: action)
            alertController.addAction(action)
        }
        
        if showCancel {
            if cancelTitle != "" {
                let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
            } else {
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
            }
        }
        if let viewController = viewC {
            
            viewController.present(alertController, animated: true, completion: nil)
            
        } else {
            let topViewController: UIViewController? = TUGHelpers.topMostViewController(rootViewController: TUGHelpers.rootViewController())
            topViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Get topmost view controller
    
    class func topMostViewController(rootViewController: UIViewController) -> UIViewController?
    {
        if let navigationController = rootViewController as? UINavigationController
        {
            return topMostViewController(rootViewController: navigationController.visibleViewController!)
        }
        
        if let tabBarController = rootViewController as? UITabBarController
        {
            if let selectedTabBarController = tabBarController.selectedViewController
            {
                return topMostViewController(rootViewController: selectedTabBarController)
            }
        }
        
        if let presentedViewController = rootViewController.presentedViewController
        {
            return topMostViewController(rootViewController: presentedViewController)
        }
        return rootViewController
    }
    
    // MARK: - Get root view controller
    
    class func rootViewController() -> UIViewController
    {
        return (UIApplication.shared.keyWindow?.rootViewController)!
    }
    func getLocalisedString(strKey:String)->String
    {
        let strValue = NSLocalizedString(strKey, comment: "")
        return strValue
    }
    func getDeviceSize()->(width:Int,height:Int){
        screenSize.width = Int(UIScreen.main.bounds.width)
        screenSize.height = Int(UIScreen.main.bounds.height)
        return screenSize
    }
    func convertStringInToCgfloat(price:String)->CGFloat{
        if let numberPrice = NumberFormatter().number(from: price) {
            let floatPrice = CGFloat(truncating: numberPrice)
            return floatPrice
        }
        return 0.0
    }
    func localnotification(){
        //creating the notification content
        let content = UNMutableNotificationContent()
        
        //adding title, subtitle, body and badge
        content.title = "Hey this is Simplified iOS"
        content.subtitle = "iOS Development is fun"
        content.body = "We are learning about iOS Local Notification"
        content.badge = 1
        
        //getting the notification trigger
        //it will be called after 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        //getting the notification request
        let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
        
        //adding the notification to notification center
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    var hideButton = true
    var property_Type = ""
    var show_badge = false
    var badge_count = UserDefaults.standard.value(forKey: "ShowBadge") as? String
    var isshowLoader = true
   
    
    
    
    class func getDate(DateStr:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: DateStr)
    }
    class func convertDateToString(PreviousDate:String) -> String
    {
        let stringInDate = PreviousDate
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: stringInDate)
        dateFormatter.dateFormat = "dd MMM,yyyy | h:mma"
        dateFormatter.locale = tempLocale
        let dateString = dateFormatter.string(from: date ?? Date())
        return  dateString
        
    }
    class func convertDateToDeliveryDateFormate(PreviousDate:String,newFormate:String,givenFormate:String) -> String
    {
        let stringInDate = PreviousDate
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = givenFormate
        
        let date = dateFormatter.date(from: stringInDate)
        dateFormatter.dateFormat = newFormate
        dateFormatter.locale = tempLocale
        let dateString = dateFormatter.string(from: date ?? Date())
        return  dateString
        
    }
    class func convertShowDateToString(PreviousDate:String) -> String
    {
        let stringInDate = PreviousDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = TIMEFORMAT.DateFormet.rawValue
        let date = dateFormatter.date(from: stringInDate)
        dateFormatter.dateFormat = TIMEFORMAT.dateShow.rawValue
        let dateString = dateFormatter.string(from: date ?? Date())
        return  dateString
        
    }
    class func setLeftDays(DiffInDays:String)->String{
        return DiffInDays + " Days Left"
    }
    class func convertPostedDate(CurrentDate:String) -> String{
        
        let stringInDate = CurrentDate
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: stringInDate)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateFormatter.locale = tempLocale
        let dateString = dateFormatter.string(from: date!)
        return dateString
        
    }
    class func convertDetailedDate(CurrentDate:String) -> String{
        
        let stringInDate = CurrentDate
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: stringInDate)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateFormatter.locale = tempLocale
        let dateString = dateFormatter.string(from: date ?? Date())
        return dateString
        
    }
    class func convertPostedDate2(CurrentDate:String) -> String{
        
        let stringInDate = CurrentDate
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: stringInDate)
        dateFormatter.dateFormat = "dd/MM/yy"
        dateFormatter.locale = tempLocale
        let dateString = dateFormatter.string(from: date!)
        return dateString
        
    }
    
    class func convertExpectedDeliveryDate(CurrentDate:String) -> String{
        
        let stringInDate = CurrentDate
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: stringInDate)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = tempLocale
        let dateString = dateFormatter.string(from: date!)
        return dateString
        
    }
    class func GetCurrentDateandTime() -> String{
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    class func GetDeviceTimeZone() -> String{
        let currentDate = Date()
        let CurrentTimeZone = NSTimeZone(abbreviation: "GMT")
        let SystemTimeZone = NSTimeZone.system as NSTimeZone
        let SystemGMTOffset: Int = SystemTimeZone.secondsFromGMT(for: currentDate)
        let timezone = String(SystemGMTOffset)
        return timezone
    }
    class func changeTime(time:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let showTime = dateFormatter.date(from: time){
            let dateFormatter2 = DateFormatter()
            dateFormatter2.timeZone =  NSTimeZone(abbreviation: "GMT+0:00") as TimeZone?
            dateFormatter2.setLocalizedDateFormatFromTemplate("h:mm a")
            
            //            dateFormatter2.setLocalizedDateFormatFromTemplate("dd-MM-yyyy h:mm a")
            let set_time = dateFormatter2.string(from: showTime).uppercased()
            return set_time
        }
        else{
            return ""
        }
    }
    //    class func ConvertDateBySpecificDate(Created_Date:String)->String{
    //
    //        guard Created_Date != "0000-00-00 00:00:00" else {
    //            return ""
    //        }
    //        let stringInDate = Created_Date
    //        let dateFormatter = DateFormatter()
    //        let tempLocale = dateFormatter.locale
    //        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    //        //"2019-04-15 08:10:17"
    //        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    //        let date = dateFormatter.date(from: stringInDate)
    //        dateFormatter.dateFormat = "dd MMM yyyy"
    //        dateFormatter.locale = tempLocale
    //        let dateString = dateFormatter.string(from: date!)
    //        return dateString
    //
    //    }
    class func ConvertDateBySpecificDate(Created_Date:String)->String{
        
        guard Created_Date != "0000-00-00 00:00:00" else {
            return ""
        }
        let stringInDate = Created_Date
        let dateFormatter = DateFormatter()
        //        let tempLocale = dateFormatter.locale
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        //        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //"2019-04-15 08:10:17"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: stringInDate)
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "dd MMM yyyy"
        //        dateFormatter.locale = tempLocale
        let dateString = dateFormatter.string(from: date!)
        return dateString
        
    }
    
    class func ConvertDateBySpecificDateforSubscriptions(Created_Date:String)->String{
        
        guard Created_Date != "00/00/0000 00:00:00" else {
            return ""
        }
        let stringInDate = Created_Date
        let dateFormatter = DateFormatter()
        //        let tempLocale = dateFormatter.locale
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        //        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //"2019-04-15 08:10:17"
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let date = dateFormatter.date(from: stringInDate)
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "dd MMM yyyy"
        //        dateFormatter.locale = tempLocale
        let dateString = dateFormatter.string(from: date!)
        return dateString
        
    }
    class func ConvertDateBySpecificDateForSubs(Created_Date:String)->String{
        
        guard Created_Date != "0000-00-00 00:00:00" &&  Created_Date != "" else {
            return ""
        }
        let stringInDate = Created_Date
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //"2019-04-15 08:10:17"
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let date = dateFormatter.date(from: stringInDate)
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.locale = tempLocale
        let dateString = dateFormatter.string(from: date!)
        return dateString
        
    }
    class func ConvertDatesBySpecificForSubscription(Created_Date:String)->String{
        
        guard Created_Date != "0000-00-00 00:00:00" &&  Created_Date != "" else {
            return ""
        }
        let stringInDate = Created_Date
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //"2019-04-15 08:10:17"
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let date = dateFormatter.date(from: stringInDate)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = tempLocale
        let dateString = dateFormatter.string(from: date!)
        return dateString
        
    }
    class func ConvertDate(Created_Date:String)->String{
        
        guard Created_Date != "0000-00-00" else {
            return ""
        }
        let stringInDate = Created_Date
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //"2019-04-15 08:10:17"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: stringInDate)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = tempLocale
        let dateString = dateFormatter.string(from: date!)
        return dateString
        
    }
    class func ConvertDateInSpecificFormat(previousDate:String)->String{
        var daysORMonth = ""
        let currentDate = TUGHelpers.getDateINtoString()
        let form = DateComponentsFormatter()
        form.maximumUnitCount = 2
        form.unitsStyle = .full
        form.allowedUnits = [.day, .hour,.minute]
        let DaysAndMonth = form.string(from: currentDate, to:TUGHelpers.getPreviousDateINtoString(previousDate:previousDate) )
        if (DaysAndMonth?.starts(with: "-"))!{
            
            let A = DaysAndMonth?.dropFirst()
            let seprateStr = A?.components(separatedBy: ",")
            daysORMonth = String(seprateStr?[0] ?? "") + " ago"
        }else{
            daysORMonth = DaysAndMonth ?? ""
            
        }
        return daysORMonth
    }
    
    class func getCurrentDateInDate() -> Date {
        let currentDate = Date()
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
        let currentTimeZoneDate = currentDate.timeIntervalSince1970
        let timezoneEpochOffset = (currentTimeZoneDate + Double(timezoneOffset))
        let timeZoneOffsetDate = Date(timeIntervalSince1970: timezoneEpochOffset)
        return timeZoneOffsetDate
    }
    
    class func GetDateDifferenceInHours(availableDate:String,createdDate:String)->String{
        let form = DateComponentsFormatter()
        form.unitsStyle = .full
        form.allowedUnits = [.hour]
        let createDate = TUGHelpers.getPreviousDateINtoString(previousDate:createdDate)
        let DaysAndMonth = form.string(from: createDate, to:TUGHelpers.getPreviousDateINtoString(previousDate:availableDate) )
        let hours = DaysAndMonth?.components(separatedBy: " ")
        return hours?.first ?? "0"
    }
    
    class  func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    class func getDateINtoString()->Date{
        
        let formatter = DateFormatter()
        let currentDate = Date()
        formatter.timeZone = NSTimeZone(abbreviation: "GMT+0:00") as TimeZone?
        formatter.locale = Locale.current
        let myString = (String(describing: currentDate))
        let yourDate: Date? = formatter.date(from:myString)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return yourDate ?? Date()
    }
    
    class func getPreviousDateINtoString(previousDate:String)->Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone =  NSTimeZone(abbreviation: "GMT+0:00") as TimeZone?
        //dateFormatter.locale = Locale.current
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let date = dateFormatter.date(from:previousDate)!
        return date
    }
    
    class func getPrevious1DateINtoString(previousDate:String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone.local
        if let dateString = dateFormatter.date(from:previousDate){
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dString = dateFormatter.string(from: dateString)
            return dString
        }
        return ""
    }
    
    class func getConvertDateInEEEFormat(eeeDate:String?)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let showDate = dateFormatter.date(from: eeeDate ?? "")
        let dateFormatter1 = DateFormatter()
        dateFormatter1.setLocalizedDateFormatFromTemplate("MMM")
        let Month = dateFormatter1.string(from: showDate!).uppercased()
        let dateFormatter2 = DateFormatter()
        dateFormatter2.setLocalizedDateFormatFromTemplate("d")
        let date = dateFormatter2.string(from: showDate!)
        let dateFormatter3 = DateFormatter()
        dateFormatter3.setLocalizedDateFormatFromTemplate("EEE")
        let day = dateFormatter3.string(from: showDate!).uppercased()
        return   day + "," + " " + Month + " " + date
    }
    
    class func decodeObject<Y: Decodable>(data: Data, completion: @escaping (Y) -> ()) {
        do {
            let model = try JSONDecoder().decode(Y.self, from: data)
            completion(model)
        } catch let jsonErr {
            print("failed to decode, \(jsonErr)")
        }
        
    }
    class func imageOrientation(_ src:UIImage)->UIImage {
        if src.imageOrientation == UIImage.Orientation.up {
            return src
        }
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch src.imageOrientation {
        case UIImage.Orientation.down, UIImage.Orientation.downMirrored:
            transform = transform.translatedBy(x: src.size.width, y: src.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
            break
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored:
            transform = transform.translatedBy(x: src.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
            break
        case UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: src.size.height)
            transform = transform.rotated(by: CGFloat(-M_PI_2))
            break
        case UIImage.Orientation.up, UIImage.Orientation.upMirrored:
            break
        }
        
        switch src.imageOrientation {
        case UIImage.Orientation.upMirrored, UIImage.Orientation.downMirrored:
            transform.translatedBy(x: src.size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImage.Orientation.leftMirrored, UIImage.Orientation.rightMirrored:
            transform.translatedBy(x: src.size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImage.Orientation.up, UIImage.Orientation.down, UIImage.Orientation.left, UIImage.Orientation.right:
            break
        }
        
        let ctx:CGContext = CGContext(data: nil, width: Int(src.size.width), height: Int(src.size.height), bitsPerComponent: (src.cgImage)!.bitsPerComponent, bytesPerRow: 0, space: (src.cgImage)!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        ctx.concatenate(transform)
        switch src.imageOrientation {
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored, UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.height, height: src.size.width))
            break
        default:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.width, height: src.size.height))
            break
        }
        let cgimg:CGImage = ctx.makeImage()!
        let img:UIImage = UIImage(cgImage: cgimg)
        return img
    }
    
    
    //MARK:-Chat Separate with section
    
    class func seperateDateWithTime(PreviousDate:String)->String{
        let stringInDate = PreviousDate
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: stringInDate)
        dateFormatter.dateFormat = "dd MMM, yyyy"
        dateFormatter.locale = tempLocale
        let dateString = dateFormatter.string(from: date!)
        return  dateString
    }
    
    class func convertChatDateToString(PreviousDate:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd MMM, yyyy"
        let dateStr = dateFormatter.string(from: PreviousDate)
        return dateStr
    }
    
    class func setTime(dateStr:String)->String{
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: dateStr)
        formatter.dateFormat = "hh:mm a"
        formatter.timeZone = NSTimeZone.local
        let dateString = formatter.string(from: date!)
        return dateString
    }
    
    
    class func getDateWithTime(PreviousDate:String)->Date{
        let arrDate = PreviousDate.components(separatedBy:" ")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: arrDate.count>0 ? arrDate[0]: "2014-12-11 11:20:20")!
    }
    
    
    class func getChatDay(chatDate:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let currentCalendar = NSCalendar.current
        if currentCalendar.isDateInToday(chatDate){
            return "Today"
        }
        else if currentCalendar.isDateInYesterday(chatDate){
            
            return "yesterday"
        }
        else if currentCalendar.isDateInTomorrow(chatDate){
            return "tomorrow"
        }
        else{
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateStr = dateFormatter.string(from: chatDate)
            return  dateStr
        }
    }
    
    class func getUniqueFileName(fileUrl: URL) -> String {
        let strExt: String = "." + (URL(fileURLWithPath: fileUrl.absoluteString).pathExtension)
        return ("\(Int(Date().timeIntervalSince1970))" + (".mp4"))
    }
    
    class func checkForReachability()->String
    {
        let reachability: Reachability? = try! Reachability()
        switch reachability!.connection {
        case .cellular:
            return "cellular"
        case .wifi:
            print("Network available via WiFi.")
            return "wifi"
        case .none:
            print("Network is not available.")
            return "no Internet"
        case .unavailable:
            return "no Internet"
        }
    }
}

class CustomSlider: UISlider {
    @IBInspectable var trackHeight: CGFloat = 10
    
//    override func trackRect(forBounds bounds: CGRect) -> CGRect {
//        let rect:CGRect = CGRect(x: 5, y: 0, width: AppObject.nav.view.frame.width - 32, height: 10)
//        return rect
//    }
}

enum TIMEFORMAT:String {
    case DAY = "MM-dd-YYYY"
    case TIME = "HH:mm"
    case DATE  = "YYYY-MM-dd"
    case DAYSTR = "dd"
    case MONTH = "MMM"
    case YEAR = "YYYY"
    case DATEINDIAN = "dd/MMM/YYYY"
    case DateFormet = "dd-MM-yyyy"
    case currentDateFormate = "dd-MMMM-yy"
    case dateShow = "dd-MMM-yyyy"
}
extension UIView {
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        let width = (self.bounds.size.width*SCREENSIZE.width)/320
        
        
        let boundsFrame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width:width , height: self.bounds.size.height)
        layer.shadowPath = UIBezierPath(rect: boundsFrame).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

var AppObject:AppDelegate
{
    return UIApplication.shared.delegate as! AppDelegate
}
