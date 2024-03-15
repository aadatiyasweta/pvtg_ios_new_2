//
//  ContactUsViewVC.swift
//  PVTG
//
//  Created by Techugo on 14/03/24.
//  Copyright © 2024 ShubhamMacmini. All rights reserved.
//

import UIKit

class ContactUsViewVC: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var msgTxtView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var outerVw: UIView!
    //MARK: - Properties
    var isvalidate = false
    var viewModel = ContactUsViewViewModel()
    var session_id = ""
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTxtField.delegate = self
        self.emailTxtField.delegate = self
        applyPlaceholderColor(to: nameTxtField)
        applyPlaceholderColor(to: emailTxtField)
//        self.outerVw.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)
    }
    // Function to apply placeholder text color to a text field
    private func applyPlaceholderColor(to textField: UITextField) {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black // Set placeholder color to black
        ]
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "", attributes: attributes)
    }
    
    //MARK: - Validation function
    func validation () -> Bool{
        isvalidate = false
        let name = self.nameTxtField.text ?? ""
        let email = self.emailTxtField.text ?? ""
        let message = self.msgTxtView.text ?? ""
        
        if  name.isEmpty  {
            showAlertWithTitle(messageBody: "Please enter name", controller: appDelegate.window?.rootViewController ?? UIViewController())
            return false
        }else if name.count < 3{
            showAlertWithTitle(messageBody: "Please enter more than 3 characters in name", controller: appDelegate.window?.rootViewController ?? UIViewController())
            return false
        } else if  email.isEmpty  {
            showAlertWithTitle(messageBody: "Please enter email", controller: appDelegate.window?.rootViewController ?? UIViewController())
            return false
        }else if !(isValidEmail(testStr: email)){
            showAlertWithTitle(messageBody: "Please enter valid email", controller: appDelegate.window?.rootViewController ?? UIViewController())
            return false
        }else if  message.isEmpty  {
            showAlertWithTitle(messageBody: "Please enter message", controller: appDelegate.window?.rootViewController ?? UIViewController())
            return false
        }
        isvalidate = true
        return isvalidate
    }
    
    @IBAction func sendBtnAction(_ sender: Any) {
        if validation(){
            guard let userid = SaveToDefaults().getUserId() else {return}
            self.viewModel.contactUsApi(user_id: userid, session_id: self.session_id, message: self.msgTxtView.text, email: self.emailTxtField.text ?? "", name: self.nameTxtField.text ?? "")
            self.viewModel.contactUsSuccesClosure = {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

extension ContactUsViewVC : UITextFieldDelegate,UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if newText.count > 150 {
            return false
        }
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        
        let newLength = currentCharacterCount + string.count - range.length
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if textField == self.nameTxtField {
            var crecter = true
            let length = maxLenghtOfTextField(text: nameTxtField, value: 30, range: range, string: string)
            if string == "" || string == "   " {
            }
            else {
                crecter = isValidName(string)
            }
            if length && crecter{
                return true
            }
            else{
                return false
            }
        }else if textField == self.emailTxtField{
            return newLength <= 30
        }
        else {
            return true
        }
    }
    
    func isValidName(_ username: String) -> Bool {
        let regularExpressionText = "[a-zA-Z\\s]+"
        let regularExpression = NSPredicate(format:"SELF MATCHES %@", regularExpressionText)
        return regularExpression.evaluate(with: username)
    }
}
