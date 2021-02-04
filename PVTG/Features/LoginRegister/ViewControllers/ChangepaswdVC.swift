//
//  ChangepaswdVC.swift
//  NPNGCoachApp
//
//  Created by Test Machine on 21/08/20.
//  Copyright © 2020 Techugo. All rights reserved.
//

import UIKit

class ChangepaswdVC: BaseViewController {
    //MARK:- IBOutlets
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
    
    //    MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        self.view.layoutIfNeeded()
        setUptheTextfields()
    }
    
    //MARK:- IBActions
    
    @IBAction func submitTap(_ sender: UIButton) {
        self.txfNewPaswd.resignFirstResponder()
        self.txfConfirmPaswd.resignFirstResponder()
        if self.validPassworddetails(confrmPaswd: self.txfConfirmPaswd.text ?? "", paswd: self.txfConfirmPaswd.text ?? "") {
            let vc = LoginVC.instance()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
}

extension ChangepaswdVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.lblPaswderr.isHidden = true
        self.lblPaswderr.text = ""
        self.lblConfrmPaswdErr.isHidden = true
        self.lblConfrmPaswdErr.text = ""
    }
}

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

    }
    
}
