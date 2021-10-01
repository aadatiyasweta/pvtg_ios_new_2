//
//  RegistrationvC.swift
//  PVTG
//
//  Created by Test Machine on 23/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit

class RegistrationvC: BaseViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var txffullName: UITextField!{
        didSet {
            txffullName.delegate = self
        }
    }
    @IBOutlet weak var txfEmail: UITextField!{
        didSet {
            txfEmail.delegate = self
        }
    }
    @IBOutlet weak var txfMobileNo: UITextField! {
        didSet {
            txfMobileNo.delegate = self
        }
    }
    @IBOutlet weak var txfPassword: UITextField!{
        didSet {
            txfPassword.delegate = self
        }
    }
    @IBOutlet weak var txfconfirmpaswd: UITextField!{
        didSet {
            txfconfirmpaswd.delegate = self
        }
    }
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var lblEmailErr: UILabel!
    @IBOutlet weak var lblPaswdErr: UILabel!
    @IBOutlet weak var lblConfrmPaswdErr: UILabel!
    @IBOutlet weak var lblmobileErr: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    //MARK:- Variables
    var regVM = RegistrationVM()
    var loginVM = LoginVM()
    var imageData = Data()
    var socialData = [String: String]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextfield()
        regVM.delegate = self
        if socialData["id"] == ""||socialData["id"] == nil {
            self.txfPassword.isHidden = false
            self.txfconfirmpaswd.isHidden = false
            
        }else{
            fetchUserData()
        }
        
    }
    
    //MARK:- IBActions
    
    
    @IBAction func profilePicBtnTap(_ sender: UIButton) {
        self.showSheet()
    }
    
    @IBAction func tapSubmit(_ sender: UIButton) {
        self.txfEmail.resignFirstResponder()
        self.txfPassword.resignFirstResponder()
        self.txffullName.resignFirstResponder()
        self.txfconfirmpaswd.resignFirstResponder()
        self.txfMobileNo.resignFirstResponder()
            if validRegistrationetails() {
                SaveToDefaults().setIsNew(isNew: true)
                if self.socialData.isEmpty{
                    self.regVM.checkinEmailPhoneApi(email: self.txfEmail.text ?? "", country_code: "+91", phone: self.txfMobileNo.text ?? "", password: self.txfPassword.text ?? "", name: self.txffullName.text ?? "", acc_type: "normal", social_id: "", pictureData: imageData)
                }else{
                    self.regVM.checkinEmailPhoneApi(email: self.txfEmail.text ?? "", country_code: "+91", phone: self.txfMobileNo.text ?? "", password: self.txfPassword.text ?? "", name: self.txffullName.text ?? "", acc_type: self.socialData["Social_type"] ?? "normal", social_id: self.socialData["id"] ?? "", pictureData: imageData)
                }
              
            }
            
        }

    @IBAction func tapLoginNow(_ sender: UIButton) {
        let vc = LoginVC.instance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension RegistrationvC: AfterRegistration{
  
    func successRegisteration() {
      
        let vc = TransformerExampleViewController.instance()
        vc.fromSignUp = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension RegistrationvC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.txffullName:
            checkingValidations()
            
        case self.txfMobileNo:
            checkingValidations()
            
        case self.txfEmail:
            checkingValidations()
            
        case self.txfPassword:
            checkingValidations()
            
        case self.txfconfirmpaswd:
            checkingValidations()
            
        default:
            debugPrint("Nothing")
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 30
        var newString = NSString()
        if textField == self.txffullName {
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            let currentString: NSString = (textField.text ?? "") as NSString
            newString = currentString.replacingCharacters(in: range, with: string) as NSString

            return (string == filtered) && newString.length <= maxLength

        }
        
        if textField == self.txfMobileNo {
            let length = (textField.text?.count ?? 0) + (string.count - range.length) <= 10
            return length
            
        }
        
        return newString.length <= maxLength
    }
}

extension RegistrationvC {
    private func validRegistrationetails()->Bool{
        if txfMobileNo.text != "" {
            if txfMobileNo.text?.count ?? 0 < 10 || txfMobileNo.text?.count ?? 0 > 10 {
                self.lblmobileErr.isHidden = false
                self.lblmobileErr.text = validNumber
                return false
            }
        }
        if txfEmail.text == "" {
            self.lblEmailErr.isHidden = false
            self.lblEmailErr.text = emptyemail
            return false
        }
        if !isValidEmail(testStr: txfEmail.text ?? ""){
            self.lblEmailErr.isHidden = false
            self.lblEmailErr.text = validEmailMessage
            return false
        }
        if txfPassword.isHidden == false {
        if txfPassword.text == ""{
            self.lblPaswdErr.isHidden = false
            self.lblPaswdErr.text = emptypaswd
            return false
        }
        if txfPassword.text?.count ?? 0 < 8 {
            self.lblPaswdErr.isHidden = false
            self.lblPaswdErr.text = invalidPaswd
            return false
        }
            if txfconfirmpaswd.text == "" {
                self.lblConfrmPaswdErr.isHidden = false
                self.lblConfrmPaswdErr.text = emptyconfirmMsg
                return false
            }
        if txfconfirmpaswd.text != txfPassword.text {
            self.lblConfrmPaswdErr.isHidden = false
            self.lblConfrmPaswdErr.text = matchconfrmpaswdMsg
            return false
        }
        }
        return true
    }
    private func checkingValidations() {
        self.lblEmailErr.isHidden = true
        self.lblEmailErr.text = ""
        self.lblPaswdErr.isHidden = true
        self.lblPaswdErr.text = ""
        self.lblConfrmPaswdErr.isHidden = true
        self.lblConfrmPaswdErr.text = ""
        self.lblmobileErr.isHidden = true
        self.lblmobileErr.text = ""
    }
    
    //MARK:- Textfield Properties
    private func setTextfield() {
        paddingTextfield(textfield: txfEmail)
        paddingTextfield(textfield: txfPassword)
        paddingTextfield(textfield: txffullName)
        paddingTextfield(textfield: txfMobileNo)
        paddingTextfield(textfield: txfconfirmpaswd)
        txfPassword.layer.borderWidth = 0.5
        txfEmail.layer.borderWidth = 0.5
        txffullName.layer.borderWidth = 0.5
        txfMobileNo.layer.borderWidth = 0.5
        txfconfirmpaswd.layer.borderWidth = 0.5
        txfEmail.placeholderColor(color: .white)
        txfPassword.placeholderColor(color: .white)
        txffullName.placeholderColor(color: .white)
        txfMobileNo.placeholderColor(color: .white)
        txfconfirmpaswd.placeholderColor(color: .white)
        txfPassword.layer.borderColor = UIColor().coloWithHexString(hex: "#FFFFFF").cgColor
        txfEmail.layer.borderColor = UIColor().coloWithHexString(hex: "#FFFFFF").cgColor
        txffullName.layer.borderColor = UIColor().coloWithHexString(hex: "#FFFFFF").cgColor
        txfMobileNo.layer.borderColor = UIColor().coloWithHexString(hex: "#FFFFFF").cgColor
        txfconfirmpaswd.layer.borderColor = UIColor().coloWithHexString(hex: "#FFFFFF").cgColor
        btnSubmit.layer.borderWidth = 0.5
        btnSubmit.layer.borderColor = UIColor().coloWithHexString(hex: "#FFFFFF").cgColor
    }
    
    private func fetchUserData() {
        self.txfPassword.isHidden = true
        self.txfconfirmpaswd.isHidden = true
        self.txffullName.text = socialData["FullName"]
        self.txfEmail.text = socialData["Email_Id"]
        if self.txfEmail.text != "" {
            self.txfEmail.isUserInteractionEnabled = false
        }
    }
    
    
    
}
extension RegistrationvC {
    func showSheet() {
        let alertSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertSheet.view.tintColor = .black
        
        let photoAction = UIAlertAction.init(title: R.string.localizable.pickfromCameraRoll(), style: .default) { (camera) in
            havePhotoAccess(completionHandler: { (isAuthorized) in
                if isAuthorized {
                    self.openImagePicker(sourceType: .photoLibrary)
                }else{
                    self.showOpenSettingAlert(title: R.string.localizable.takePhoto(), message: photosPermissionNeededMessage, completion: {
                        
                    })
                }
            })
            
        }
        
        let cameraAction = UIAlertAction.init(title: R.string.localizable.takePhoto(), style: .default) { (camera) in
            haveCameraAccess(completionHandler: { (isAuthorized) in
                if isAuthorized {
                    self.openImagePicker(sourceType: .camera)
                }else{
                    self.showOpenSettingAlert(title: R.string.localizable.cameraAccessDenied(), message: cameraPermissionNeededMessage, completion: {
                        
                    })
                }
            })
            
        }
        let cancelAction = UIAlertAction.init(title: R.string.localizable.cancel(), style: .cancel, handler: nil)
        alertSheet.addAction(cameraAction)
        alertSheet.addAction(photoAction)
        alertSheet.addAction(cancelAction)
        self.present(alertSheet, animated: true, completion: nil)
    }
    func openImagePicker(sourceType:UIImagePickerController.SourceType){
        
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController.init()
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        picker.dismiss(animated: true) {
            if info[.originalImage] != nil {
                
                if let image = info[.originalImage] as? UIImage{
                    self.imageData = image.jpegData(compressionQuality: 0.5) ?? Data()
                    DispatchQueue.main.async {
                        
                        self.userImage.image = image
                        self.userImage.contentMode = .scaleAspectFill
                        
                        
                    }
                    
                }
            }
            
        }
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
  
}
