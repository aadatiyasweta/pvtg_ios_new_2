//
//  DreamVC.swift
//  NPNGUserApp
//
//  Created by Techugo on 12/08/20.
//  Copyright © 2020 Techugo. All rights reserved.
//

import UIKit

class ForgotPaswordVC: BaseViewController {
    
   //MARK: - Outlets
    @IBOutlet weak var txfEmail: UITextField!{
        didSet {
            txfEmail.delegate = self
        }
    }
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblemailError: UILabel!
    
    //MARK: - Properties
    let id = 2
    var paswdVM = LoginVM()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.paswdVM.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        self.view.layoutIfNeeded()
       setVSViewShadow(radius: 10, color: .black, view: self.btnBack, opacity: 0.12)
        paddingTextfield(textfield: txfEmail)
        txfEmail.layer.borderWidth = 0.3
        txfEmail.layer.borderColor = UIColor().coloWithHexString(hex: "#05d9bd").cgColor
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func nextBtnTap(_ sender: UIButton) {
        self.txfEmail.resignFirstResponder()
        if validdetails(email: self.txfEmail.text ?? "") {
            self.paswdVM.forgotApi(email: self.txfEmail.text ?? "", is_resend: "0")
        }
    }
}

//MARK: - TEXT FIELD DELEGATES
extension ForgotPaswordVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.lblemailError.isHidden = true
        self.lblemailError.text = ""
    }
}

//MARK: - VIEW CONTROLLER EXTENSION
extension ForgotPaswordVC {
        private func validdetails(email : String)->Bool{
            if email == "" {
                self.lblemailError.isHidden = false
                self.lblemailError.text = emptyemail
                return false
            } else if !isValidEmail(testStr: email){
                self.lblemailError.isHidden = false
                self.lblemailError.text = validEmailMessage
                return false
            }
            return true
        }
}

//MARK: - CUSTOM DELEGATE
extension ForgotPaswordVC: AfterLoginSuccess {
    func inCorrectOtpMessage() {
        print("In Correct Msg")
    }
    
    func otpCheckSuccess() {
    }
    
    func changePaswdSucces() {
    }
    
    func forgotSuccess() {
        let vc = OTPVC.instance()
        vc.email = txfEmail.text ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func createNewuser() {
    }
    
    func loginSuccess() {
    }
    
    func failure(msg: String) {
        showAlert(strTitle: msg)
    }
}
