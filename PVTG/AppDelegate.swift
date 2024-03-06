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

//import Firebase
//import FirebaseAuth
//import FirebaseMessaging
//import FirebaseCore

import FirebaseMessaging
import UserNotifications
import Firebase


@UIApplicationMain
class AppDelegate:UIResponder,UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate{
    var window: UIWindow?
    var tabBarVc : UITabBarController?
    var currentVC : UIViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
                fireBaseSetup(application: application)
                Messaging.messaging().delegate = self
        // Override point for customization after application launch.
        IQKeyboardManager.shared().isEnabled = true
        GMSServices.provideAPIKey("AIzaSyC6hyx1WnYOhTnbbvdYR-f7nWvVqyHgn2k")
//     GMSServices.provideAPIKey("AIzaSyCz9l1ZKpCvUXFlkT4sopsN8OKi6plvBmk")

//     GMSPlacesClient.provideAPIKey("AIzaSyCz9l1ZKpCvUXFlkT4sopsN8OKi6plvBmk")
//
        GMSPlacesClient.provideAPIKey("AIzaSyCcR9sGmXLeCBwVXIOH2ciEsGlgmHIik98")
        
        
       // FirebaseApp.configure()
              //  Messaging.messaging().delegate = self
        
        //remoteNotification(application: application)
    // Stripe.setDefaultPublishableKey(stripeLivePublishKey) // live
     Stripe.setDefaultPublishableKey(stripeTestPublishableKey) // development
        Bundle.setLanguage(SaveToDefaults().getAppLang() ?? "en")
        let vc = SplashVC.navigation()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        return true
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
                   if userInfo["gcm.notification.type"] as? String == "reminder"{
                          if let session_id = userInfo["gcm.notification.session_id"] as? String, let session_name = userInfo["gcm.notification.session_name"] as? String{
                              print(session_id,session_name)
                              if SaveToDefaults().getAccessToken() != nil{
                                  if application.applicationState == .active{
                                      self.performAttendingAlert(name: session_name, id: session_id)
                                  }
                              }
                          }
                      }
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
        
        @available(iOS 10.0, *)
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            _ = response.notification.request.content.categoryIdentifier
            let object = response.notification.request.content.userInfo as! [String : AnyObject]
            print(object)
//            if UserDefaults.isLogin ?? false {
//                if isNetworkConnectionEnable {
//                    if "chat" == object["gcm.notification.type"] as? String{
//                        setTabViewChatListController()
//                    }
//                }
            }
    
//        func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {                   print("fcmToken",fcmToken ?? "")
//                        if let  fcmTokenn = fcmToken {
//                            UserDefaults.standard.set(fcmTokenn, forKey:"deviceToken")
//                         }
//                        SaveToDefaults().setFcmToken(token: "\(String(describing: fcmToken))")
//        }
//
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//            Messaging.messaging().apnsToken = deviceToken
//        }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
//    {
//        _ = notification.request.content.categoryIdentifier
//
//                completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
//
//                let object = notification.request.content.userInfo as? [String : AnyObject]
//    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//
//        _ = response.notification.request.content.categoryIdentifier
//                let object = response.notification.request.content.userInfo as! [String : AnyObject]
//
//    }
//
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//
//                print("userInfo",userInfo)
////                if userInfo["gcm.notification.type"] as? String == "reminder"{
////                    if let session_id = userInfo["gcm.notification.session_id"] as? String, let session_name = userInfo["gcm.notification.session_name"] as? String{
////                        print(session_id,session_name)
////                        if SaveToDefaults().getAccessToken() != nil{
////                            if application.applicationState == .active{
////                                self.performAttendingAlert(name: session_name, id: session_id)
////                            }
////                        }
////                    }
////                }
//     //           completionHandler(.newData)
//
//    }
    
//    @available(iOS 10.0, *)
//    internal func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
////
////        if let Notification_type = response.notification.request.content.userInfo["aps"] as? NSDictionary{
////
////        }
//        let userInfo = response.notification.request.content.userInfo
//        print("didReceive")
//        if userInfo["gcm.notification.type"] as? String == "reminder"{
//        if let session_id = userInfo["gcm.notification.session_id"] as? String, let session_name = userInfo["gcm.notification.session_name"] as? String{
//            print(session_id,session_name)
//            if SaveToDefaults().getAccessToken() != nil{
////                if UIApplication.shared.applicationState == .inactive{
// //                   DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
////                        self.performAttendingAlert(name: session_name, id: session_id)
////                    }
////                }else{
//                    self.performAttendingAlert(name: session_name, id: session_id)
// //               }
//            }
//        }
//        }
//       // completionHandler()
//    }
    
    func checkLoginStatus() {
        if SaveToDefaults().getAccessToken() == nil || SaveToDefaults().getAccessToken() == "" {
            if SaveToDefaults().getIsNew() == nil || SaveToDefaults().getIsNew() == false {
                let vc = OnboardingVC.navigation()
                window?.rootViewController = vc
                window?.makeKeyAndVisible()
            } else{
                let vc = LoginVC.navigation()
                window?.rootViewController = vc
                window?.makeKeyAndVisible()
            }
        } else {
            let vc = TabBarControllerViewController.navigation()
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
        }
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
        
    func performAttendingAlert(name : String, id : String){
//        let viewObj = ReminderView.initWith(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
//        viewObj?.id = id
//        viewObj?.titleLbl.text = R.string.localizable.willYouAttending(name)
//        viewObj?.delegate = self
//        window?.addSubview(viewObj!)
        
        Helper.shared.showAlertWithCallback(buttonText: "Yes", buttonText2: "No", title: "Reminder", message: "Will you still be attending your holistic session?", controller: window?.rootViewController ?? UIViewController()) { [weak self] result in
            guard let self else{return}
            if result{
                self.hitApi(id: id)
            }else{
                Helper.shared.showAlertWithCallback(buttonText: "Yes", buttonText2: "No", title: "Reminder", message: "Will you still be attending your holistic session?", controller: self.window?.rootViewController ?? UIViewController()) { [weak self] result in
                    guard let self else{return}
                    if result{
                        print("Yes Clicked")
                    }else{
                        Helper.shared.showAlertWithCallback(buttonText: "Yes", buttonText2: "No", title: "Reminder", message: "Will you still be attending your holistic session?", controller: self.window?.rootViewController ?? UIViewController()) { [weak self] result in
                            guard let self else{return}
                            if result{
                                print("Yes Clicked")
                            }else{
                                print("no ")
                            }
                        }
                    }
                }
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
