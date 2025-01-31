//
//  RegistrationVM.swift
//  PVTG
//
//  Created by Test Machine on 23/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit
protocol AfterRegistration: AnyObject {
    func successRegisteration()
}
class RegistrationVM: BaseVm {
    
    //MARK: - Properties
    public weak var delegate: AfterRegistration?
    var model: LoginResult?
    
    //MARK: - VALIDATE REGISTRATION DETAILS
    func validRegistartiondetails(email : String , paswd : String, name: String, confirmPaswd: String, mobile: String)->Bool{
        if name == ""{
            showMesssgeWindow(msg: emptyNameMessage)
            return false
        } else if email == "" {
            showMesssgeWindow(msg: emptyemail)
            return false
        } else if !isValidEmail(testStr: email){
            showMesssgeWindow(msg: validEmailMessage)
            return false
        } else if paswd == ""{
            showMesssgeWindow(msg: emptypaswd)
            return false
        } else if confirmPaswd == "" {
            showMesssgeWindow(msg: emptyconfirmMsg)
            return false
        } else if paswd != confirmPaswd {
            showMesssgeWindow(msg: matchconfrmpaswdMsg)
            return false
        }
        return true
    }
    
    //MARK: - API for registration
    func signupApi(email: String, password: String, name: String, country_code: String, phone: String, acc_type: String, social_id: String, pictureData: Data) {
        let prams : [String : Any] = ["name" : name, "email": email, "country_code": country_code, "phone": phone, "acc_type": acc_type, "social_id": social_id, "password": password,"language" : SaveToDefaults().getAppLang() ?? "en"]
        self.show()
        api_manager.upload(registrationUrl(), pictureData, params: prams, "image", header: header(), completion: { (err, response, code) in
            self.dismiss()
            if let json = response{
                if json["statusCode"] == 200 {
                    let data = try? json["result"].rawData()
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try? jsonDecoder.decode(LoginResult.self, from: data!)
                    self.model = responseModel
                    self.setDataInLocal()
                    SaveToDefaults().setEmail(value: self.model?.email)
                    SaveToDefaults().setUserId(id: self.model?.user_id)
                    SaveToDefaults().setAccessToken(value: self.model?.user_token)
                    self.delegate?.successRegisteration()
                }
                else {
                    showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
            }
        })
        }
    
    func setDataInLocal(){
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(self.model) {
            SaveToDefaults().setLogindata(data: encodedData)
        }
        defaults.synchronize()
    }
    
    //MARK: - API for checking email/phone existence Userapi/check_email_phone
    func checkinEmailPhoneApi(email: String, country_code: String, phone: String, password: String, name: String, acc_type: String, social_id: String, pictureData: Data) {
        let prams : [String : Any] = ["email": email, "country_code": country_code, "phone": phone,"language" : SaveToDefaults().getAppLang() ?? "en"]
        self.show()
        api_manager.POSTApi(checkEmailPhoneUrl(), param: prams, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    self.signupApi(email: email, password: password, name: name, country_code: country_code, phone: phone, acc_type: acc_type, social_id: social_id, pictureData: pictureData)
                } else if json["statusCode"] == 300{
                    showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                } else if json["statusCode"] == 400 {
                    showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
            }
        }
    }
    
}
