//
//  AppDelegate.swift
//  PVTG
//
//  Created by Test Machine on 18/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import AuthenticationServices
import UserNotifications
import FirebaseMessaging
import FirebaseCore
import FirebaseInstanceID
import SVProgressHUD
import AVFoundation
import GooglePlaces
import GoogleMaps
import GoogleSignIn
import FirebaseAuth


@UIApplicationMain
class AppDelegate:UIResponder,UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate{
    var window: UIWindow?
    var tabBarVc : UITabBarController?
    var currentVC : UIViewController?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        GMSServices.provideAPIKey("AIzaSyC6hyx1WnYOhTnbbvdYR-f7nWvVqyHgn2k")
        GMSPlacesClient.provideAPIKey("AIzaSyCcR9sGmXLeCBwVXIOH2ciEsGlgmHIik98")
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        remoteNotification(application: application)
  
        Bundle.setLanguage(SaveToDefaults().getAppLang() ?? "en")
        
        let vc = SplashVC.navigation()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        //       // checkLoginStatus()
        //  checkLoginStatus()
        return true
    }
    
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
    
    func remoteNotification(application:UIApplication) {
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
        self.instanceId()
        
    }
    func instanceId(){
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                SaveToDefaults().setFcmToken(token: result.token)
            }
        }
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        SaveToDefaults().setFcmToken(token: "\(fcmToken)")
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("didRegisterForRemoteNotificationsWithDeviceToken")
        Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
        Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
    }
    //MARK:- Function For Open URL
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool{
        let googleDidHandle = GIDSignIn.sharedInstance()?.handle(url)
        let facebookDidHandle = appDelegate.application(app, open: url, options: options)
        Auth.auth().canHandle(url)
        return  facebookDidHandle || googleDidHandle!
        //return googleDidHandle!
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("didReceiveRemoteNotification",userInfo)
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        application.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    }
    
    func hitDeviceTokenApi(isLogout : Bool? = false){
        let param : [String:Any] = [
            "device_token": !isLogout! ? SaveToDefaults().getFcmToken() ?? "" : "123",
            "device_type": "Ios",
            "user_id" : SaveToDefaults().getUserId() ?? ""
        ]
        print(header() ?? [:])
        api_manager.PUTApi(updateDeviceTokenUrl(), param: param, header: header()) { (response, err, stausCode) in
//            if isLogout!{
//                // removeLoginDetails()
//                DispatchQueue.main.async {
//                    
//                }
//            }
            print(response ?? "Nil")
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("didReceive")
        if userInfo["gcm.notification.type"] as? String == "reminder"{
        if let session_id = userInfo["gcm.notification.session_id"] as? String, let session_name = userInfo["gcm.notification.session_name"] as? String{
            print(session_id,session_name)
            if SaveToDefaults().getAccessToken() != nil{
                if UIApplication.shared.applicationState == .inactive{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        self.performAttendingAlert(name: session_name, id: session_id)
                    }
                }else{
                    self.performAttendingAlert(name: session_name, id: session_id)
                }
               
            }
        }
        }
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
    func performAttendingAlert(name : String, id : String){
        let viewObj = ReminderView.initWith(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        viewObj?.id = id
        viewObj?.titleLbl.text = R.string.localizable.willYouAttending(name)
        viewObj?.delegate = self
        window?.addSubview(viewObj!)
    }
    func hitApi(id : String){
        let param : [String:String] = ["user_id" : SaveToDefaults().getUserId() ?? "" , "session_id":id ]
        api_manager.POSTApi(attendingSession(), param: param, header: header()) { (json, err, statusCode) in
            
        }
    }
}
extension AppDelegate : ReminderViewYesProtocol{
    func getYesCallback(id:String) {
        self.hitApi(id: id)
    }
}
