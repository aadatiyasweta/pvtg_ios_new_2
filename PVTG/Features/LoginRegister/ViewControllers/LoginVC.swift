//
//  LoginVC.swift
//  PVTG
//
//  Created by Test Machine on 23/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import AuthenticationServices

class LoginVC: BaseViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    //MARK:- IBOutlets
    
    @IBOutlet weak var txfPassword: UITextField!{
        didSet{
            self.txfPassword.delegate = self
        }
    }
    
    @IBOutlet weak var logintoYouAcLbl: UILabel!
    @IBOutlet weak var txfEmail: UITextField!{
        didSet{
            self.txfEmail.delegate = self
        }
    }
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblEmailErr: UILabel!
    @IBOutlet weak var lblPaswdErr: UILabel!
    
    //MARK:- Variables
    var loginVM = LoginVM()
    var Socialdata = [String:String]()
    var fbHelper   = Facebook()

    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.logintoYouAcLbl.text = R.string.localizable.logHolisticTravel()
        self.lblEmailErr.isHidden = true
        self.lblPaswdErr.isHidden = true
        loginVM.delegate = self
        setTextfield()
        googleLogin()
    }
    //MARK:- Textfield properties
    private func setTextfield() {
        paddingTextfield(textfield: txfEmail)
        paddingTextfield(textfield: txfPassword)
        txfEmail.placeholderColor(color: .white)
        txfPassword.placeholderColor(color: .white)
        txfPassword.layer.borderWidth = 0.5
        txfEmail.layer.borderWidth = 0.5
        txfPassword.layer.borderColor = UIColor().coloWithHexString(hex: "#FFFFFF").cgColor
        txfEmail.layer.borderColor = UIColor().coloWithHexString(hex: "#FFFFFF").cgColor
        btnSubmit.layer.borderWidth = 0.5
        btnSubmit.layer.borderColor = UIColor().coloWithHexString(hex: "#FFFFFF").cgColor
    }
    //MARK:- IBActions
    @IBAction func tapForgotPassword(_ sender: UIButton) {
        let vc = ForgotPaswordVC.instance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapSubmit(_ sender: UIButton) {
        self.txfEmail.resignFirstResponder()
        self.txfPassword.resignFirstResponder()
        if self.validLogindetails(email: self.txfEmail.text ?? "", paswd: self.txfPassword.text ?? "") {
             SaveToDefaults().setIsNew(isNew: true)
//            let vc = TabBarControllerViewController.instance()
//                   self.navigationController?.pushViewController(vc, animated: true)
            self.loginVM.loginApi(email: self.txfEmail.text ?? "", password: self.txfPassword.text ?? "")
        } 
    }
    @IBAction func tapLoginWithFb(_ sender: UIButton) {
        doCodeForFacebookLogin()
    }
    @IBAction func tapLoginWithGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func tapLoginWithApple(_ sender: UIButton) {
        if #available(iOS 13.0, *) {
            handleAppleIdRequest()
        } else {
            // Fallback on earlier versions
        }

    }
    
    @IBAction func tapRegiterNow(_ sender: UIButton) {
        let vc = RegistrationvC.instance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoginVC: AfterLoginSuccess {
    func forgotSuccess() {
        debugPrint("forgotSuccess")
    }
    
    func otpCheckSuccess() {
        debugPrint("otpCheckSuccess")
    }
    
    func changePaswdSucces() {
        debugPrint("changePaswdSucces")
    }
    
    func createNewuser() {
        let vc = RegistrationvC.instance()
        vc.socialData = Socialdata
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func failure(msg: String) {
        showAlert(strTitle: msg)
    }
    
    
    func loginSuccess() {
        SaveToDefaults().setIsNew(isNew: true)
        let vc = TabBarControllerViewController.instance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension LoginVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.lblEmailErr.isHidden = true
        self.lblEmailErr.text = ""
        self.lblPaswdErr.isHidden = true
        self.lblPaswdErr.text = ""
    }
}

extension LoginVC: GIDSignInDelegate, FacebookDelegate{
    //MARK: - Google SignIn
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if (error == nil)
        {
            let gPlusId = user.userID // For client-side use only!
            let name = user.profile.name
            var email:String = ""
            
            Socialdata["FullName"] = name
            if let emailID = user.profile.email{
                email = emailID
                Socialdata["Email_Id"] = email
            }else{
                email = ""
            }
            Socialdata["Social_type"] = "google"
            Socialdata["id"] = gPlusId
            signIn.signOut()
            makeRequestToSocialSignup(accountType: "google", social_id: gPlusId ?? "")
        }
        else
        {
            print("\(error.localizedDescription)")
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!)
    {
        // Perform any operations when the user disconnects from app here.
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!)
    {
        
        //testing========
    }
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!)
    {
        
        self.present(viewController, animated: true, completion: nil)
        
    }
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:-FacebookLogIn
    func doCodeForFacebookLogin()
    {
        fbHelper = Facebook()
        fbHelper.doLogout()
        fbHelper.delegate = self
        fbHelper.doLoginWithFacebook()
    }
    func fbUserInfoFail(err: NSError) {
        
    }
    func fbLoginSuccess()
    {
        fbHelper.getUserInformation()
    }
    func fbLoginCancelled()
    {
    }
    func fbLoginFail(error err:NSError)
    {
        print(fbLoginFail)
    }
    func fbUserInfoSuccess(result:AnyObject)
    {
        
        var social_Username = ""
        var email:String = ""
        var fid:String = ""
        
        
        if  let result1 = result as? NSDictionary
        {
            let fbResponse = result1.mutableCopy() as? NSMutableDictionary
            
            if let name = fbResponse?.value(forKey: "name") as? String{
                social_Username = name
                Socialdata["FullName"] = social_Username
            }
            
            if let emails = fbResponse?.value(forKey: "email") as? String
            {
                email = emails
                Socialdata["Email_Id"] = email
            }
            if let fids = fbResponse?.value(forKey: "id") as? String
            {
                fid = fids
                Socialdata["id"] = fid
            }
            
            Socialdata["Social_type"] = "facebook"
            makeRequestToSocialSignup(accountType: "fb", social_id: fid )
        }
    }
    
}
extension LoginVC {
    func makeRequestToSocialSignup(accountType: String, social_id: String ){
        self.loginVM.socialLoginApi(social_id: social_id, acc_type: accountType)
    }

    private func validLogindetails(email : String , paswd : String)->Bool{
        if email == "" {
            self.lblEmailErr.isHidden = false
            self.lblEmailErr.text = emptyemail
            return false
        } else if !isValidEmail(testStr: email){
            self.lblEmailErr.isHidden = false
            self.lblEmailErr.text = validEmailMessage
            return false
        } else if paswd == ""{
            self.lblPaswdErr.isHidden = false
            self.lblPaswdErr.text = emptypaswd
            return false
        } else if paswd.count < 8 {
            self.lblPaswdErr.isHidden = false
            self.lblPaswdErr.text = invalidPaswd
            return false
        }
        return true
    }
    
    @available(iOS 13.0, *)
    func handleAppleIdRequest() {
         let appleIDProvider = ASAuthorizationAppleIDProvider()
              let request = appleIDProvider.createRequest()
              request.requestedScopes = [.fullName, .email]
              let authorizationController = ASAuthorizationController(authorizationRequests: [request])
              authorizationController.delegate = self
              authorizationController.presentationContextProvider = self
              authorizationController.performRequests()
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
           print(error.localizedDescription)
       }
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if #available(iOS 13.0, *) {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                let appleId = appleIDCredential.user
                let appleUserFirstName = appleIDCredential.fullName?.givenName
                let appleUserLastName = appleIDCredential.fullName?.familyName
                let appleUserEmail = appleIDCredential.email
                 Socialdata["id"] = appleId
                 Socialdata["FullName"] = "\(appleUserFirstName ?? "") \(appleUserLastName ?? "")"
                 Socialdata["Email_Id"] = appleUserEmail
                 Socialdata["Social_type"] = "apple"
                 makeRequestToSocialSignup(accountType: "apple", social_id: appleId )
            }
        } else {
            // Fallback on earlier versions
        }

        }

    //Mark:-GoogleSignup
    func googleLogin() {
        GIDSignIn.sharedInstance().clientID = "213231135715-4bt41406ei6um842vpd6ntolaap3j0p4.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self
    }
    
}
