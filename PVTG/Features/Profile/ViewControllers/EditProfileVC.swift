//
//  EditProfileVC.swift
//  PVTG
//
//  Created by Test Machine on 07/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit

class EditProfileVC: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var imguser: UIImageView!
    @IBOutlet weak var txfUserName: UITextField!{
        didSet{
            txfUserName.delegate = self
        }
    }
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txfmobileNo: UITextField!{
        didSet {
            txfmobileNo.delegate = self
        }
    }
    @IBOutlet weak var vwContainMobileField: UIView!
    @IBOutlet weak var txfmail: UITextField!{
        didSet{
            txfmail.delegate = self
        }
    }
    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var vw3: UIView!
    @IBOutlet weak var lblNameErr: UILabel!
    @IBOutlet weak var lblMobileerr: UILabel!
    @IBOutlet weak var lblMailErr: UILabel!
    @IBOutlet weak var vwContainUserImg: UIView!
    
    //MARK: - Properties
    private var imageData = Data()
    private var selectedImage = UIImage()
    private var vm = ProfileViewModel()
    var userDta: User_profile?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.delegate = self
        setData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        customLayoutOfView()
    }
    
    func customLayoutOfView(){
        vw1.layer.cornerRadius = 7
        vw1.layer.borderWidth = 0.5
        vw1.layer.borderColor = UIColor().coloWithHexString(hex: "#05d9db").cgColor
        vw2.layer.cornerRadius = 7
        vw2.layer.borderWidth = 0.5
        vw2.layer.borderColor = UIColor().coloWithHexString(hex: "#05d9db").cgColor
        vw3.layer.cornerRadius = 7
        vw3.layer.borderWidth = 0.5
        vw3.layer.borderColor = UIColor().coloWithHexString(hex: "#05d9db").cgColor
        paddingTextfield(textfield: txfmail)
        paddingTextfield(textfield: txfUserName)
        paddingTextfield(textfield: txfmobileNo)
        setVSViewShadow(radius: 10, color: .black, view: self.btnBack, opacity: 0.12)
        setVSViewShadow(radius: 10, color: .black, view: self.vwContainUserImg, opacity: 0.12)
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func btnTapChangePicture(_ sender: UIButton) {
        showSheet()
    }
    
    @IBAction func SubmitTap(_ sender: UIButton) {
        guard let userid = SaveToDefaults().getUserId() else {return}
        if validRegistrationetails() {
            self.vm.updateProfileApi(user_id: userid, image: self.imageData, email: self.txfmail.text ?? "", country_code: "+91", phone: self.txfmobileNo.text ?? "", name: self.txfUserName.text ?? "")
        }
    }
}

//MARK: - ViewController Extension
extension EditProfileVC {
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
        
        let deletePhotoAction = UIAlertAction.init(title: R.string.localizable.deletePhoto(), style: .default) { (camera) in
            
        }
        
        let cancelAction = UIAlertAction.init(title: R.string.localizable.cancel(), style: .cancel, handler: nil)
        alertSheet.addAction(cameraAction)
        alertSheet.addAction(photoAction)
        alertSheet.addAction(cancelAction)
        alertSheet.addAction(deletePhotoAction)
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
                        self.selectedImage = image
                        self.imguser.image = image
                        
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func setData() {
        self.txfUserName.text = userDta?.name
        self.txfmobileNo.text = userDta?.phone
        self.txfmail.text = userDta?.email
        SaveToDefaults().setProfilePic(value: userDta?.user_image ?? "")
        loadImage(userDta?.user_image ?? "", self.imguser, activity: nil, defaultImage: #imageLiteral(resourceName: "more"))
        
        if(userDta?.user_image ?? "" == ""){
            imguser.image = UIImage(named: "more")
        }
    }
    
}

//MARK: - CUSTOM DELEGATE
extension EditProfileVC: UpdateTheProfile {
    func updateProfile() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - TEXT FIELD DELEGATES
extension EditProfileVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.txfUserName:
            checkingValidations()
            
        case self.txfmobileNo:
            checkingValidations()
            
        case self.txfmail:
            checkingValidations()
            
        default:
            debugPrint("Nothing")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 30
        var newString = NSString()
        if textField == self.txfUserName {
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            let currentString: NSString = (textField.text ?? "") as NSString
            newString = currentString.replacingCharacters(in: range, with: string) as NSString
            return (string == filtered) && newString.length <= maxLength
        }
        
        if textField == self.txfmobileNo {
            let length = (textField.text?.count ?? 0) + (string.count - range.length) <= 10
            return length
        }
        return newString.length <= maxLength
    }
}

//MARK: - VIEW CONTROLLER EXTENSION
extension EditProfileVC {
    private func validRegistrationetails()->Bool{
        if txfmail.text == "" {
            self.lblMailErr.isHidden = false
            self.lblMailErr.text = emptyemail
            return false
        }
        if !isValidEmail(testStr: txfmail.text ?? ""){
            self.lblMailErr.isHidden = false
            self.lblMailErr.text = validEmailMessage
            return false
        }
        return true
    }
    
    private func checkingValidations() {
        self.lblMailErr.isHidden = true
        self.lblMailErr.text = ""
        self.lblMobileerr.isHidden = true
        self.lblMobileerr.text = ""
    }
}
