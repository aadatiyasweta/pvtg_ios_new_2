//
//  DreamVC.swift
//  NPNGUserApp
//
//  Created by Techugo on 12/08/20.
//  Copyright © 2020 Techugo. All rights reserved.
//

import UIKit

class ForgotPaswordVC: BaseViewController {
    //    MARK:- IBOutlets
    @IBOutlet weak var txfEmail: UITextField!{
        didSet {
            txfEmail.delegate = self
        }
    }
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblemailError: UILabel!
    
    
    //    MARK:- Variable
    let id = 2
    var paswdVM = LoginVM()
    
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
    
    
    
    @IBAction func nextBtnTap(_ sender: UIButton) {
        self.txfEmail.resignFirstResponder()
        if validdetails(email: self.txfEmail.text ?? "") {
            self.paswdVM.forgotApi(email: self.txfEmail.text ?? "")
//        let otp = OTPVC.instance()
//        self.navigationController?.pushViewController(otp, animated: true)
        }
    }
    
}

extension ForgotPaswordVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.lblemailError.isHidden = true
        self.lblemailError.text = ""
    }
}

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

extension ForgotPaswordVC: AfterLoginSuccess {
    func createNewuser() {
        debugPrint("Create new User")
    }
    func loginSuccess() {
        debugPrint("Succes")
        let vc = OTPVC.instance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func failure(msg: String) {
        showAlert(strTitle: msg)
    }
    
    
}
