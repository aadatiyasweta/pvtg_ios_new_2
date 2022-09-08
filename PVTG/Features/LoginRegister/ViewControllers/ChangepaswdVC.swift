//
//  ChangepaswdVC.swift
//  NPNGCoachApp
//
//  Created by Test Machine on 21/08/20.
//  Copyright © 2020 Techugo. All rights reserved.
//

import UIKit

class ChangepaswdVC: BaseViewController {
   
    //MARK: - Outlets
    @IBOutlet weak var txfNewPaswd: UITextField!{
        didSet {
            txfNewPaswd.delegate = self
        }
    }
    @IBOutlet weak var txfConfirmPaswd: UITextField! {
        didSet {
            txfConfirmPaswd.delegate = self
        }
    }
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblPaswderr: UILabel!
    @IBOutlet weak var lblConfrmPaswdErr: UILabel!
    
    //MARK: - Properties
    var email = ""
    var vm = LoginVM()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.delegate = self
        DispatchQueue.main.async {
            self.setUptheTextfields()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        self.view.layoutIfNeeded()
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func submitTap(_ sender: UIButton) {
        self.txfNewPaswd.resignFirstResponder()
        self.txfConfirmPaswd.resignFirstResponder()
        if self.validPassworddetails(confrmPaswd: self.txfConfirmPaswd.text ?? "", paswd: self.txfNewPaswd.text ?? "") {
            self.vm.changePasswordApi(email: self.email, password: txfNewPaswd.text ?? "")
        }
    }
}

//MARK: - TEXT FIELD DELEGATES
extension ChangepaswdVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.lblPaswderr.isHidden = true
        self.lblPaswderr.text = ""
        self.lblConfrmPaswdErr.isHidden = true
        self.lblConfrmPaswdErr.text = ""
    }
}

//MARK: - VIEW CONTROLLER EXTENSION
extension ChangepaswdVC {
    private func validPassworddetails(confrmPaswd : String , paswd : String)->Bool{
        if paswd == "" {
            self.lblPaswderr.isHidden = false
            self.lblPaswderr.text = emptyNewpaswd
            return false
        } else if paswd.count < 8{
            self.lblPaswderr.isHidden = false
            self.lblPaswderr.text = invalidPaswd
            return false
        } else if confrmPaswd == "" {
            self.lblConfrmPaswdErr.isHidden = false
            self.lblConfrmPaswdErr.text = emptyconfirmMsg
            return false
        }else if confrmPaswd != paswd {
            self.lblConfrmPaswdErr.isHidden = false
            self.lblConfrmPaswdErr.text = matchconfrmpaswdMsg
            return false
        }
        return true
    }
    
    func setUptheTextfields() {
        setVSViewShadow(radius: 10, color: .black, view: self.btnBack, opacity: 0.12)
        paddingTextfield(textfield: txfNewPaswd)
        paddingTextfield(textfield: txfConfirmPaswd)
        txfNewPaswd.layer.borderWidth = 0.3
        txfNewPaswd.layer.borderColor = UIColor().coloWithHexString(hex: "#05d9bd").cgColor
        txfConfirmPaswd.layer.borderWidth = 0.3
        txfConfirmPaswd.layer.borderColor = UIColor().coloWithHexString(hex: "#05d9bd").cgColor
        self.lblPaswderr.isHidden = true
        self.lblConfrmPaswdErr.isHidden = true
        txfNewPaswd.textColor = .black
        txfConfirmPaswd.textColor = .black
        txfNewPaswd.isSecureTextEntry = true
        txfConfirmPaswd.isSecureTextEntry = true
    }
}

//MARK: - AFTER LOGIN  SUCCESS DELEGATE
extension ChangepaswdVC: AfterLoginSuccess {
    func loginSuccess() {
        debugPrint("loginSuccess")
    }
    
    func failure(msg: String) {
        debugPrint("failure")
    }
    
    func createNewuser() {
        debugPrint("createNewuser")
    }
    
    func forgotSuccess() {
        debugPrint("forgotSuccess")
    }
    
    func otpCheckSuccess() {
        debugPrint("otpCheckSuccess")
    }
    
    func changePaswdSucces() {
        let vc = LoginVC.instance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
