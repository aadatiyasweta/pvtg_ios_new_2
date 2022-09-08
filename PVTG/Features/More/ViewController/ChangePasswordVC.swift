//
//  ChangepaswdVC.swift
//  NPNGCoachApp
//
//  Created by Test Machine on 21/08/20.
//  Copyright © 2020 Techugo. All rights reserved.
//

import UIKit

class ChangePasswordVC: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var txfOldpasswd: UITextField!{
        didSet {
            txfOldpasswd.delegate = self
        }
    }
    
    @IBOutlet weak var txfNewPaswd: UITextField!{
            didSet {
                txfNewPaswd.delegate = self
            }
        }
    
    @IBOutlet weak var txfConfirmPaswd: UITextField!{
        didSet {
                      txfConfirmPaswd.delegate = self
                  }
    }
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblConfrmErr: UILabel!
    @IBOutlet weak var lblNewErr: UILabel!
    @IBOutlet weak var lblOldErr: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    //MARK: - Properties
    var changPaswrdVM = ChangePasswordVM()
   
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        changPaswrdVM.delegateChangePassword = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillLayoutSubviews() {
           self.view.layoutIfNeeded()
           uiSetupofTextfields()
       }
   
    //MARK: - BUTTON ACTION
    @IBAction func submitTap(_ sender: UIButton) {
        self.txfOldpasswd.resignFirstResponder()
        self.txfNewPaswd.resignFirstResponder()
        self.txfConfirmPaswd.resignFirstResponder()
        if validPassword(confrmPaswd: txfConfirmPaswd.text ?? "", paswdNew: txfNewPaswd.text ?? "", paswdOld: txfOldpasswd.text ?? ""){
            loadApi()
        }
    }
}

//MARK: - TEXT FIELD DELEGATES
extension ChangePasswordVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.lblOldErr.isHidden = true
        self.lblOldErr.text = ""
        self.lblNewErr.isHidden = true
        self.lblNewErr.text = ""
        self.lblConfrmErr.isHidden = true
        self.lblConfrmErr.text = ""

    }
}

//MARK: - VIEW CONTROLLER EXTENSION
extension ChangePasswordVC {
    private func validPassword(confrmPaswd : String , paswdNew : String, paswdOld:String)->Bool{
        if paswdOld == "" {
            self.lblOldErr.isHidden = false
            self.lblOldErr.text = emptyOldPaswd
            return false
        }
        if paswdNew == ""{
            self.lblNewErr.isHidden = false
            self.lblNewErr.text = emptyNewpaswd
            return false
        }
        if paswdNew.count < 8{
            self.lblNewErr.isHidden = false
            self.lblNewErr.text = invalidPaswd
            return false
        }

        if confrmPaswd == "" {
            self.lblConfrmErr.isHidden = false
            self.lblConfrmErr.text = emptyconfirmMsg
            return false
        }
        if confrmPaswd != paswdNew {
            self.lblConfrmErr.isHidden = false
            self.lblConfrmErr.text = matchconfrmpaswdMsg
            return false
        }
        return true
    }
    
    func loadApi() {
           if let userid = SaveToDefaults().getUserId() {
            self.changPaswrdVM.changePasswordApi(user_id: userid, old_password: txfOldpasswd.text ?? "", new_password: txfNewPaswd.text ?? "")
           }
       }
    func uiSetupofTextfields() {
    setVSViewShadow(radius: 10, color: .black, view: self.btnBack, opacity: 0.12)
    paddingTextfield(textfield: txfNewPaswd)
    paddingTextfield(textfield: txfConfirmPaswd)
    paddingTextfield(textfield: txfOldpasswd)
    txfNewPaswd.layer.borderWidth = 0.3
    txfNewPaswd.layer.borderColor = UIColor().coloWithHexString(hex: "#05d9bd").cgColor
    txfOldpasswd.layer.borderWidth = 0.3
    txfOldpasswd.layer.borderColor = UIColor().coloWithHexString(hex: "#05d9bd").cgColor
    txfConfirmPaswd.layer.borderWidth = 0.3
    txfConfirmPaswd.layer.borderColor = UIColor().coloWithHexString(hex: "#05d9bd").cgColor
    }
    
}

//MARK: -  CUSTOM DELEGATE
extension ChangePasswordVC: ChangePassword {
    func getReponse() {
        self.showAlertWithConfirmation1(R.string.localizable.passwrdChangedSuccess(), withTitle: appName, itsController: self) { (succss) in
               self.navigationController?.popViewController(animated: true)
        }
    
    }
}

