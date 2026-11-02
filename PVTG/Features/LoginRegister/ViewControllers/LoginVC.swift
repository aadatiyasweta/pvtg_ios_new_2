//
//  LoginVC.swift
//  PVTG
//
//  Created by Test Machine on 23/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit
//import Firebase
import GoogleSignIn
import AuthenticationServices
import KeychainSwift

class LoginVC: BaseViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    // Login is a starting point (after onboarding, logout or password reset), so no swiping back from it
    override var allowsSwipeBack: Bool {
        return false
    }

    //MARK: - Outlets
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
   // @IBOutlet weak var stackViewWidthConst: NSLayoutConstraint!
    @IBOutlet weak var hidePasswordButton: UIButton!
    
    //MARK: - Properties
    var loginVM = LoginVM()
    var Socialdata = [String:String]()
    var fbHelper   = Facebook()
    
    var keyChain = KeychainSwift()
    var fname = ""
    var lname = ""
    var email = ""
    
    // Dark rounded backgrounds behind the error messages (readable on the photo)
    private var errorBgObservers: [NSKeyValueObservation] = []
    private var errorStackDefaultSpacing: CGFloat = 12
    private var forgotButtonTopConstraint: NSLayoutConstraint?
    private var forgotButtonDefaultGap: CGFloat = 10
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        if(SaveToDefaults().getAppLang() == "en"){
//            stackViewWidthConst.constant = 266
//        }else {
//            stackViewWidthConst.constant = 310
//        }
        self.lblEmailErr.isHidden = true
        self.lblPaswdErr.isHidden = true
        setupErrorBackgrounds()
        loginVM.delegate = self
        setTextfield()
        googleLogin()
    }
    
    //MARK: - SET TEXTFIELD
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
    
    //MARK: - BUTTON ACTION
    @IBAction func hidePasswordButtonAction(_ sender: Any) {
        if hidePasswordButton.isSelected{
            hidePasswordButton.isSelected = false
            txfPassword.isSecureTextEntry = true
        }else{
            hidePasswordButton.isSelected = true
            txfPassword.isSecureTextEntry = false
        }
    }
    @IBAction func tapForgotPassword(_ sender: UIButton) {
        let vc = ForgotPaswordVC.instance()
        self.navigationController?.pushViewController(vc, animated: true)
//        let vc = TransformerExampleViewController.instance()
//        vc.fromSignUp = true
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapSubmit(_ sender: UIButton) {
        self.txfEmail.resignFirstResponder()
        self.txfPassword.resignFirstResponder()
        if self.validLogindetails(email: self.txfEmail.text ?? "", paswd: self.txfPassword.text ?? "") {
            SaveToDefaults().setIsNew(isNew: true)
                  self.loginVM.loginApi(email: self.txfEmail.text ?? "", password: self.txfPassword.text ?? "")
        }
        
//        let numbers = [0]
//              let _ = numbers[1]
    }
    
    func doubleValue(number: inout Int) {
        number *= 2
    }
    
    @IBAction func tapLoginWithFb(_ sender: UIButton) {
        doCodeForFacebookLogin()
    }
    
    @IBAction func tapLoginWithGoogle(_ sender: UIButton) {
//        let config = GIDConfiguration(clientID: "213231135715-6tq4dmpkanreubpk3krueo47hvedluco.apps.googleusercontent.com")
//                
//        GIDSignIn.sharedInstance.configuration = config
//        GIDSignIn.sharedInstance.signIn(withPresenting: self)
        initGoogleLogin()
    }
    
    @IBAction func tapLoginWithApple(_ sender: UIButton) {
        if #available(iOS 13.0, *) {
            handleAppleIdRequest()
        } else {
        }
    }
    
    @IBAction func tapRegiterNow(_ sender: UIButton) {
        let vc = RegistrationvC.instance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func initGoogleLogin(){
        
            let signInConfig = GIDConfiguration.init(clientID: "213231135715-6tq4dmpkanreubpk3krueo47hvedluco.apps.googleusercontent.com")
        
        GIDSignIn.sharedInstance.configuration = signInConfig
        
//        let gPlusId = user.userID // For client-side use only!
//        let name = user.profile?.name
//        var email:String = ""
//        
//        Socialdata["FullName"] = name
//        if let emailID = user.profile?.email{
//            email = emailID
//            Socialdata["Email_Id"] = email
//        }else{
//            email = ""
//        }
//        Socialdata["Social_type"] = "google"
//        Socialdata["id"] = gPlusId
//        signIn.signOut()
//        makeRequestToSocialSignup(accountType: "google", social_id: gPlusId ?? "")
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { user, error in
                guard error == nil else { return }
            guard let user = user?.user else{
                    //assertionFailure("errror found in google plus sign in")
                    return
                }
                
                if let fName = user.profile?.name, fName.count > 0 {
                    self.Socialdata["FullName"] = fName
                }
            
            
               // self.loginViewModelObj.fname = self.social_userFName
                
//                if let lName = user.profile?.familyName, lName.count > 0 {
//                    self.social_userLName = lName
//                    
//                }
              //  self.loginViewModelObj.lname = self.social_userLName
                
                if let email = user.profile?.email, email.count > 0 {
                    self.Socialdata["Email_Id"] = email
                    
                }
                //self.loginViewModelObj.email = self.social_userEmail
                
                let token = user.userID
                guard token?.count ?? 0 > 0 else {
                    return
                }
               // self.social_token = token ?? ""
               
            self.Socialdata["id"] = token
            self.Socialdata["Social_type"] = "google"
                
                //API Call.
            self.makeRequestToSocialSignup(accountType: "google", social_id: token ?? "")
                
            }
        }
}

//MARK: - AFTER LOGIN SUCCESS DELEGATE
extension LoginVC: AfterLoginSuccess {
    func inCorrectOtpMessage() {
        print("In Correct Msg")
    }
    
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
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            
               
        SaveToDefaults().setIsNew(isNew: true)
        let vc = TabBarControllerViewController.instance() 
        self.navigationController?.pushViewController(vc, animated: true)
            
        })
    }
}

//MARK: - TEXT FIELD DELEGATE
extension LoginVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.lblEmailErr.isHidden = true
        self.lblEmailErr.text = ""
        self.lblPaswdErr.isHidden = true
        self.lblPaswdErr.text = ""
    }
}

//MARK: - GOOGLE AND FACEBOOK DELEGATES
//extension LoginVC: GIDSignInDelegate, FacebookDelegate{
extension LoginVC: FacebookDelegate{
    //MARK: - Google SignIn
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if (error == nil)
        {
            let gPlusId = user.userID // For client-side use only!
            let name = user.profile?.name
            var email:String = ""
            
            Socialdata["FullName"] = name
            if let emailID = user.profile?.email{
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
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!)
    {
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!)
    {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - FACEBOOK LOGIN
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

//MARK: - VIEW CONTROLLER EXTENSION
extension LoginVC {
    func makeRequestToSocialSignup(accountType: String, social_id: String ){
//        self.loginVM.socialLoginApi(social_id: social_id, acc_type: accountType, email: self.Socialdata["Email_Id"] ?? "")
        self.loginVM.socialLoginApi(social_id: social_id, acc_type: accountType, email: self.Socialdata["Email_Id"] ?? "")
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
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let appleId = appleIDCredential.user
            let appleUserFirstName = appleIDCredential.fullName?.givenName
            let appleUserLastName = appleIDCredential.fullName?.familyName
            let appleUserEmail = appleIDCredential.email
            Socialdata["id"] = appleId
            Socialdata["FullName"] = "\(appleUserFirstName ?? "") \(appleUserLastName ?? "")"
            Socialdata["Email_Id"] = appleUserEmail
            Socialdata["Social_type"] = "apple"
            
            if let firstName = appleIDCredential.fullName?.givenName, firstName.count > 0 {
                self.fname = firstName
                self.keyChain.set(fname, forKey:"apple_f_name" )
                
                print("Apple Fisrt Name: \(fname)")
            } else {
                self.fname = keyChain.get("apple_f_name") ?? ""
                print("Apple Fisrt Name: \(fname)")
            }
            
            if let lastName = appleIDCredential.fullName?.familyName, lastName.count > 0 {
                self.lname = lastName
                self.keyChain.set(lname, forKey:"apple_l_name" )
                print("Apple Last Name: \(lname)")
            } else {
                self.lname = keyChain.get("apple_l_name") ?? ""
                print("Apple Last Name: \(lname)")
            }
            Socialdata["FullName"] = "\(self.fname) \(self.lname)"
            
            if let email = appleIDCredential.email, email.count > 0 {
                self.email = email
                self.keyChain.set(email, forKey:"email" )
                print("Apple userEmail: \(email)")
            } else {
                self.email = keyChain.get("email") ?? ""
                print("Apple userEmail: \(email)")
            }
            Socialdata["Email_Id"] = self.email
            
            makeRequestToSocialSignup(accountType: "apple", social_id: appleId )
        }
    }
    
    //MARK: - Google Signup Method
    func googleLogin() {
//        GIDSignIn.sharedInstance.clientID = "213231135715-4bt41406ei6um842vpd6ntolaap3j0p4.apps.googleusercontent.com"
//        GIDSignIn.sharedInstance.delegate = self
//        GIDSignIn.sharedInstance.presentingViewController = self
    }
    
}

//MARK: - ERROR MESSAGE BACKGROUND
extension LoginVC {
    private func setupErrorBackgrounds() {
        // Both error labels sit in rows of the same vertical stack view
        let stack = lblEmailErr.superview?.superview as? UIStackView
        if let stack = stack {
            errorStackDefaultSpacing = stack.spacing
            // "Forgot Password?" is pinned below the stack view; find that gap so it can grow while an error shows
            forgotButtonTopConstraint = stack.superview?.constraints.first {
                ($0.firstItem as? UIButton) != nil && ($0.secondItem as? UIStackView) === stack
                    && $0.firstAttribute == .top && $0.secondAttribute == .bottom
            }
            forgotButtonDefaultGap = forgotButtonTopConstraint?.constant ?? 10
        }
        addErrorBackground(to: lblEmailErr, below: txfEmail)
        addErrorBackground(to: lblPaswdErr, below: txfPassword)
    }
    
    /// Puts the label inside a dark, semi-transparent rounded box (4pt padding) that shows and hides with the label.
    private func addErrorBackground(to label: UILabel, below field: UITextField) {
        guard let parent = label.superview else { return }
        let padding: CGFloat = 4
        let bg = UIView()
        bg.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        bg.layer.cornerRadius = 6
        bg.isUserInteractionEnabled = false
        bg.translatesAutoresizingMaskIntoConstraints = false
        parent.insertSubview(bg, belowSubview: label)
        
        // Move the label down by the padding so the box starts right under the text field
        for c in parent.constraints where (c.firstItem as? UILabel) === label && c.firstAttribute == .top {
            c.constant = padding
        }
        // Keep long messages on one line inside the field width
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.trailingAnchor.constraint(lessThanOrEqualTo: field.trailingAnchor, constant: -(padding + 4)).isActive = true
        
        NSLayoutConstraint.activate([
            bg.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: -padding),
            bg.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: padding),
            bg.topAnchor.constraint(equalTo: label.topAnchor, constant: -padding),
            bg.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: padding)
        ])
        bg.isHidden = label.isHidden
        
        // The existing code shows/hides the label; the box follows automatically
        errorBgObservers.append(label.observe(\.isHidden, options: [.new]) { [weak self, weak bg] lbl, _ in
            DispatchQueue.main.async {
                bg?.isHidden = lbl.isHidden
                self?.updateErrorSpacing()
            }
        })
    }
    
    /// Adds room for the error box only while an error is visible, so nothing overlaps the next field or "Forgot Password?"
    private func updateErrorSpacing() {
        if let stack = lblEmailErr.superview?.superview as? UIStackView {
            stack.spacing = lblEmailErr.isHidden ? errorStackDefaultSpacing : errorStackDefaultSpacing + 12
        }
        forgotButtonTopConstraint?.constant = lblPaswdErr.isHidden ? forgotButtonDefaultGap : forgotButtonDefaultGap + 16
        UIView.animate(withDuration: 0.2) { self.view.layoutIfNeeded() }
    }
}
