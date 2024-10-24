//
//  AppDelegate.swift
//  PVTG
//
//  Created by Test Machine on 18/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit
import IQKeyboardManager
import AuthenticationServices

import SVProgressHUD
import AVFoundation
import GooglePlaces
import GoogleMaps
import GoogleSignIn
import Stripe
import FirebaseMessaging
import UserNotifications
import Firebase


@UIApplicationMain
class AppDelegate:UIResponder,UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate{
    var window: UIWindow?
    var tabBarVc : UITabBarController?
    var currentVC : UIViewController?
    var navigation = UINavigationController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 3.0)
        FirebaseApp.configure()
        fireBaseSetup(application: application)
        Messaging.messaging().delegate = self
        // Override point for customization after application launch.
        IQKeyboardManager.shared().isEnabled = true
        //IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        if let apiKey = getAPIKeyFromPlist() {
            GMSServices.provideAPIKey(apiKey)
            GMSPlacesClient.provideAPIKey(apiKey)
        }
        
//        GMSPlacesClient.provideAPIKey("AIzaSyC6hyx1WnYOhTnbbvdYR-f7nWvVqyHgn2k")
//        GMSServices.provideAPIKey("AIzaSyC6hyx1WnYOhTnbbvdYR-f7nWvVqyHgn2k")
    // Stripe.setDefaultPublishableKey(stripeLivePublishKey) // live
     Stripe.setDefaultPublishableKey(stripeTestPublishableKey) // development
        Bundle.setLanguage(SaveToDefaults().getAppLang() ?? "en")
//        let vc = SplashVC.navigation()
//        window?.rootViewController = vc
//        window?.makeKeyAndVisible()
        //setSplashVC()
        checkLoginStatus()
        return true
    }
    
    func checkLoginStatus() {
        if SaveToDefaults().getAppLang() ?? "" == "" || SaveToDefaults().getAppLang() == nil{
//            let vc = LanguageChnageVC.navigation()
//            window?.rootViewController = vc
//            window?.makeKeyAndVisible()
            setChangeLanguageVC()
        }else{
            if SaveToDefaults().getAccessToken() == nil || SaveToDefaults().getAccessToken() == "" {
                if SaveToDefaults().getIsNew() == nil || SaveToDefaults().getIsNew() == false {
//                    let vc = OnboardingVC.navigation()
//                    window?.rootViewController = vc
//                    window?.makeKeyAndVisible()
                    setOnboardingVC()
                } else{
//                    let vc = LoginVC.navigation()
//                    window?.rootViewController = vc
//                    window?.makeKeyAndVisible()
                    setLoginVC()
                }
            } else {
//                let vc = TabBarControllerViewController.navigation()
//                window?.rootViewController = vc
//                window?.makeKeyAndVisible()
                setTabBarControllerVC()
            }
        }
       }
    
    func setSplashVC(){
        let vc = onboarding.instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
        self.navigation = UINavigationController(rootViewController: vc)
        navigation.navigationBar.isHidden = true
        navigation.interactivePopGestureRecognizer?.isEnabled = false
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
    
    
    
    
    func fireBaseSetup(application: UIApplication) {
            if #available(iOS 10.0, *) {
                // For iOS 10 display notification (sent via APNS)
                UNUserNotificationCenter.current().delegate = self

                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    completionHandler: {_,_ in })
            } else {
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                application.registerUserNotificationSettings(settings)
            }
            application.registerForRemoteNotifications()
        }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
         func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
            print("fcmToken:\(String(describing: fcmToken))")
             if let  fcmTokenn = fcmToken {
                UserDefaults.standard.set(fcmTokenn, forKey:"deviceToken")
                                     }
                SaveToDefaults().setFcmToken(token: "\(String(describing: fcmToken))")
            
        }
       
        func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            print("userInfo",userInfo)
                   
                      completionHandler(.newData)
        }
        
        @available(iOS 10.0, *)
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
        {

            let object = notification.request.content.userInfo as! [String : AnyObject]
//            if isNetworkConnectionEnable {
//                NotificationCenter.default.post(name: Notification.Name("chatBageUpdate"), object: nil)
//                completionHandler([.alert,.sound, .badge])
//            }
            completionHandler([.alert,.sound, .badge])
        }
        
     
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo as? [String : AnyObject]
        print(userInfo)
        if userInfo?["gcm.notification.type"] as? String == "reminder"{
            if let session_id = userInfo?["gcm.notification.session_id"] as? String, let session_name = userInfo?["gcm.notification.session_name"] as? String, let notificationString = userInfo?["gcm.notification.data"] as? String {
                let notificationData = convertToDictionary(text: notificationString)
                if let bookingId = notificationData?["booking_id"] as? String, let bodyMessage = notificationData?["body"] as? String, let rescheduleCount = notificationData?["reschedule_count"] as? String, let paymentIdSTr = notificationData?["payment_id"] as? String, let chargeIdStr = notificationData?["charge_id"] as? String, let amountSTr = notificationData?["amount"] as? String, let bookingDateStr = notificationData?["booking_date"] as? String{
                    print(session_id,session_name,rescheduleCount)
                    //                               if SaveToDefaults().getAccessToken() != nil{
                    //                                   if application.applicationState == .active{
                    self.performAttendingAlert(name: session_name, id: session_id,message: bodyMessage, bookingId: bookingId, rescheduleCount: rescheduleCount, amount: amountSTr, payment_id: paymentIdSTr, charge_id: chargeIdStr, bookingDateStr: bookingDateStr)
                 
                    //                                   }
                    //                               }
                }
            }
        }else if userInfo?["gcm.notification.type"] as? String == "session_follow_up"{
            if let session_id = userInfo?["gcm.notification.session_id"] as? String, let session_name = userInfo?["gcm.notification.session_name"] as? String, let notificationString = userInfo?["gcm.notification.data"] as? String {
                let notificationData = convertToDictionary(text: notificationString)
                    print(session_id,session_name)
                if let bodyMessage = notificationData?["body"] as? String{
                    self.performSessionFollowupAlert(name: session_name, id: session_id,message: bodyMessage)
                }
                }
        }
//        else if let userInfo = userInfo as? [String: Any],
//           let aps = userInfo["aps"] as? [String: Any],
//           let alert = aps["alert"] as? [String: Any],
//           let title = alert["title"] as? String {
//            print("Title: \(title)")
//            
//            if(title == "Session Reminder" || title == "reminder"){
//                
//            }
//        } 
        else if let userInfo = userInfo as? [String: Any],
             let type = userInfo["type"] as? String {
              print("Type: \(type)")
            if(type == "Session Reminder" || type == "reminder"){
                if let session_id = userInfo["session_id"] as? String, let session_name = userInfo["session_name"] as? String {
//                    , let notificationString = userInfo?["gcm.notification.data"] as? String {
//                    let notificationData = convertToDictionary(text: notificationString)
                    if let bookingId = userInfo["booking_id"] as? String, let bodyMessage = userInfo["body"] as? String, let rescheduleCount = userInfo["reschedule_count"] as? String, let paymentIdSTr = userInfo["payment_id"] as? String, let chargeIdStr = userInfo["charge_id"] as? String, let amountSTr = userInfo["amount"] as? String, let bookingDateStr = userInfo["booking_date"] as? String{
                        print(session_id,session_name,rescheduleCount)

                        self.performAttendingAlert(name: session_name, id: session_id,message: bodyMessage, bookingId: bookingId, rescheduleCount: rescheduleCount, amount: amountSTr, payment_id: paymentIdSTr, charge_id: chargeIdStr, bookingDateStr: bookingDateStr)
                    }
                }
            }
            else if(type == "session_follow_up"){
                if let session_id = userInfo["session_id"] as? String, let session_name = userInfo["session_name"] as? String {
                    //let notificationString = userInfo?["gcm.notification.data"] as? String {
                    if let bodyMessage = userInfo["body"] as? String{
                        self.performSessionFollowupAlert(name: session_name, id: session_id,message: bodyMessage)
                    }
                }
            }else{
                
            }
          }
        else {
            print("Title not found.")
        }
    }
    
    
    func convertToDictionary(text: String) -> [String: Any]? {
                if let data = text.data(using: .utf8) {
                    do {
                        return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    } catch {
                     //   Helpers.showAlert(strTitle: error.localizedDescription)
                    }
                }
                return nil
            }
    
//    func checkLoginStatus() {
//        if SaveToDefaults().getAccessToken() == nil || SaveToDefaults().getAccessToken() == "" {
//            if SaveToDefaults().getIsNew() == nil || SaveToDefaults().getIsNew() == false {
////                let vc = OnboardingVC.navigation()
////                window?.rootViewController = vc
////                window?.makeKeyAndVisible()
//                setOnboardingVC()
//            } else{
////                let vc = LoginVC.navigation()
////                window?.rootViewController = vc
////                window?.makeKeyAndVisible()
//                setLoginVC()
//            }
//        } else {
////            let vc = TabBarControllerViewController.navigation()
////            window?.rootViewController = vc
////            window?.makeKeyAndVisible()
//            setTabBarControllerVC()
//        }
//    }
    
    func setOnboardingVC(){
        let vc = onboarding.instantiateViewController(withIdentifier: "OnboardingVC") as! OnboardingVC
        self.navigation = UINavigationController(rootViewController: vc)
        navigation.navigationBar.isHidden = true
        navigation.interactivePopGestureRecognizer?.isEnabled = false
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
    
    func setLoginVC(){
        let vc = login.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigation = UINavigationController(rootViewController: vc)
        navigation.navigationBar.isHidden = true
        navigation.interactivePopGestureRecognizer?.isEnabled = false
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
    
    func setTabBarControllerVC(){
        let vc = home.instantiateViewController(withIdentifier: "TabBarControllerViewController") as! TabBarControllerViewController
        self.navigation = UINavigationController(rootViewController: vc)
        navigation.navigationBar.isHidden = true
        navigation.interactivePopGestureRecognizer?.isEnabled = false
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
    
    func setChangeLanguageVC(){
        let vc = onboarding.instantiateViewController(withIdentifier: "LanguageChnageVC") as! LanguageChnageVC
        self.navigation = UINavigationController(rootViewController: vc)
        navigation.navigationBar.isHidden = true
        navigation.interactivePopGestureRecognizer?.isEnabled = false
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
        
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        print("didRegisterForRemoteNotificationsWithDeviceToken")
//        Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
//        Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
//        Messaging.messaging().token { (token, error) in
//               if let error = error {
//                   print("Error fetching remote instance ID: \(error.localizedDescription)")
//               } else if let token = token {
//                   UserDefaults.standard.set(token, forKey:"deviceToken")
//               }
//           }
//    }
    
    //MARK: - Function For Open URL
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool{
        let googleDidHandle = GIDSignIn.sharedInstance.handle(url)
        let facebookDidHandle = appDelegate.application(app, open: url, options: options)
        //Auth.auth().canHandle(url)
        return  facebookDidHandle || googleDidHandle
    }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
//    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func hitDeviceTokenApi(isLogout : Bool? = false){
        let deviceToken = UserDefaults.standard.object(forKey: "deviceToken") ?? "1234"
        let param : [String:Any] = [
            "device_token": !isLogout! ? deviceToken : "123",
            "device_type": "Ios",
            "user_id" : SaveToDefaults().getUserId() ?? ""
        ]
        print(header() ?? [:])
        api_manager.PUTApi(updateDeviceTokenUrl(), param: param, header: header()) { (response, err, stausCode) in
            print(response ?? "Nil")
        }
    }
    
    func hitDeleteUserAccountApi(isDelete : Bool? = false){
        let deviceToken = UserDefaults.standard.object(forKey: "deviceToken") ?? "1234"
        let param : [String:Any] = [
            "device_token": !isDelete! ? deviceToken : "123",
            "device_type": "Ios",
            "user_id" : SaveToDefaults().getUserId() ?? ""
        ]
        print(header() ?? [:])
        api_manager.DeleteApi(deleteAccountUrl(), param: param, header: header()) { (response, err, stausCode) in
            print(response ?? "Nil")
        }
    }
        
    func performAttendingAlert(name : String, id : String, message:String, bookingId: String, rescheduleCount: String, amount: String, payment_id: String, charge_id: String, bookingDateStr: String){
//        let viewObj = ReminderView.initWith(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
//        viewObj?.id = id
//       viewObj?.titleLbl.text = R.string.localizable.willYouAttending(name)
//        viewObj?.delegate = self
//        window?.addSubview(viewObj!) // ashi1
        Helper.shared.showAlertWithCallback(buttonText: R.string.localizable.yes(), buttonText2: R.string.localizable.no(), title: R.string.localizable.notificationtitle(), message: message, controller: window?.rootViewController ?? UIViewController()) { [weak self] result in
            guard let self else{return}
            if result{
                self.hitApi(id: "\(id)")
                    Helper.shared.showAlertWithCallback(buttonText:  R.string.localizable.view(), buttonText2: R.string.localizable.later() , title: R.string.localizable.viewpolicy(), message: R.string.localizable.viewLatePolicy(), controller: self.window?.rootViewController ?? UIViewController()) { [weak self] result in
                        guard let self else{return}
                        if result{
                            print("Yes Clicked")
                            let vc = PrivacyPolicyVC.instance()
                            vc.type = R.string.localizable.latePolicy()
                           // vc.type = "Late fee Policy"
                            vc.isFromReschedule = true
                            vc.rescheduleCountStr = rescheduleCount
                           // vc.url = cancelPolicy
                            vc.url = "https://techugoserver.info/pvtg_dev/late_fee.html" // development
                            vc.isComingCancelBooking = false
                            self.navigation.pushViewController(vc, animated: true)
                        }else{
                           
                            }
                        }
                    }
            else { // here after first click no
                        Helper.shared.showAlertWithCallback(buttonText: R.string.localizable.reschedule(), buttonText2: R.string.localizable.no(), title: R.string.localizable.notificationtitle(), message: R.string.localizable.rescheduleSession(), controller: self.window?.rootViewController ?? UIViewController()) { [weak self] result in
                            guard let self else{return}
                            if result{
                                print("Yes Clicked")
                                let vc = SessionDetailVC.instance()
                                vc.sessionId = "\(id)"
                                vc.bookingId = bookingId
                                vc.rescheduleCountStr = rescheduleCount
                                vc.controllerId = 1
                                vc.isFromReschedule = false // at first it was false
                                vc.isFromRescheduleNo = true // at first it was true - both changed due to client requirement
        //                                SaveToDefaults().setSessionTimeId(name: self.homevm.model?.all_result?[indexPath.row].session_image)
                                self.navigation.pushViewController(vc, animated: true)
                            }else{
                                print("no ")
                                // due to client requirement it is commented
//                                let vc = SessionDetailVC.instance()
//                                vc.sessionId = "\(id)"
//                                vc.bookingId = bookingId
//                                vc.rescheduleCountStr = rescheduleCount
//                                vc.controllerId = 0
//                                vc.isFromReschedule = true
//                                vc.isFromRescheduleNo = false
//                                self.navigation.pushViewController(vc, animated: true)
                                let vc = PrivacyPolicyVC.instance()
                                vc.type = R.string.localizable.cancelPolicy()
                                vc.isFromReschedule = true
                                vc.sessionId = "\(id)"
                                vc.bookingId = bookingId
                                vc.rescheduleCountStr = rescheduleCount
                                vc.url = cancelPolicy
                                vc.isComingCancelBooking = true
                                
                                vc.getChargeId = charge_id
                                vc.timeStr = bookingDateStr
                                vc.payment_id = payment_id
                                vc.ammountSTr = amount
                                
                                self.navigation.pushViewController(vc, animated: true)
                            }
                    }
                }
            }
    }
    
    func performSessionFollowupAlert(name : String, id : String, message:String){
        Helper.shared.showAlertWithCallback(buttonText: R.string.localizable.view(), buttonText2: R.string.localizable.later() , title:  R.string.localizable.followupsession(), message: message, controller: window?.rootViewController ?? UIViewController()) { [weak self] result in
            guard let self else{return}
            if result{
                let vc = SessionDetailVC.instance()
                vc.sessionId = "\(id)"
                vc.controllerId = 0
                vc.isFromFollowup = true
                self.navigation.pushViewController(vc, animated: true)
            }
        }
    }
    
    func hitApi(id : String){
        let param : [String:String] = ["user_id" : SaveToDefaults().getUserId() ?? "" , "session_id":id ]
        api_manager.POSTApi(attendingSession(), param: param, header: header()) { (json, err, statusCode) in
        }
    }
}

//MARK: - CUSTOM DELEGATE
extension AppDelegate : ReminderViewYesProtocol{
    func getYesCallback(id:String) {
        self.hitApi(id: id)
    }
}

//
func getAPIKeyFromPlist() -> String? {
    if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
       let plist = NSDictionary(contentsOfFile: path),
       let apiKey = plist.object(forKey: "Google_Api_Key") as? String {
        print("GoogleApiKey \(apiKey)")
        return apiKey
    }
    return nil
}
