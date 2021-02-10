//
//  LoginVM.swift
//  PVTG
//
//  Created by Test Machine on 23/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit
protocol AfterLoginSuccess: class {
    func loginSuccess()
    func failure(msg: String)
    func createNewuser()
    func forgotSuccess()
    func otpCheckSuccess()
    func changePaswdSucces()
    
}
class LoginVM: BaseVm {
    weak var delegate: AfterLoginSuccess?
    var model: LoginResult?
    
    func validLogindetails(email : String , paswd : String, txfemail: UITextField, txfpaswd: UITextField)->Bool{
        if email == "" {
            showMesssgeJustBelowView(view: txfemail, msg: emptyemail)
            return false
        } else if !isValidEmail(testStr: email){
            showMesssgeWindow(msg: validEmailMessage)
            return false
        } else if paswd == ""{
            showMesssgeWindow(msg: emptypaswd)
            return false
        }
        return true
    }
    
    func setDataInLocal(){
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(self.model) {
            SaveToDefaults().setLogindata(data: encodedData)
        }
        defaults.synchronize()
    }
    
    func getDataFromLocal()->LoginResult?{
        if let decodedData  = SaveToDefaults().getLoginData(){
            let decoder = JSONDecoder()
            if let model = try? decoder.decode(LoginResult.self, from: decodedData) {
                self.model = model
                return model
            }
        }
        return nil
        
    }
    
    //API to Login
    func loginApi(email: String, password: String) {
        let prams : [String : Any] = ["email": email, "password": password]
        print(prams)
        self.show()
        api_manager.POSTApi(loginUrl(), param: prams, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    let data = try? json["result"].rawData()
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try? jsonDecoder.decode(LoginResult.self, from: data!)
                    self.model = responseModel
                    self.setDataInLocal()
                    SaveToDefaults().setUserId(id: self.model?.user_id)
                    SaveToDefaults().setAccessToken(value: self.model?.user_token)
                    self.delegate?.loginSuccess()
                    
                }
                else {
                    self.delegate?.failure(msg: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
            }
        }
    }
    
    //API to ForgotPassword
    func forgotApi(email: String, is_resend: String) {
        let prams : [String : Any] = ["email": email, "is_resend": is_resend]
        print(prams)
        self.show()
        api_manager.POSTApi(forgotUrl(), param: prams, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    if is_resend == "1" {
                        showAlert(strTitle:  json["APICODERESULT"].string ?? somethingWentWrongMessage)
                    }else {
                    self.delegate?.forgotSuccess()
                    }
                }
                else {
                    self.delegate?.failure(msg: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
            }
        }
    }
    func otpCheckApi(email: String, otp: String) {
        let prams : [String : Any] = ["email": email, "otp": otp]
           print(prams)
           self.show()
        api_manager.GETApi(otpCheckUrl(email: email, otp: otp), param: nil, header: header()) { (response, err, code) in
               self.dismiss()
               if let json = response{
                   debugPrint(json)
                   if json["statusCode"] == 200 {
                       self.delegate?.otpCheckSuccess()
                   }
                   else {
                       self.delegate?.failure(msg: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                   }
               }else{
                   showAlert(strTitle: somethingWentWrongMessage)
               }
           }
       }
    func changePasswordApi(email: String, password: String) {
           let prams : [String : Any] = ["email": email, "password": password]
              print(prams)
              self.show()
           api_manager.POSTApi(resetPasswordUrl(), param: prams, header: header()) { (response, err, code) in
                  self.dismiss()
                  if let json = response{
                      debugPrint(json)
                      if json["statusCode"] == 200 {
                          self.delegate?.changePaswdSucces()
                      }
                      else {
                          self.delegate?.failure(msg: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                      }
                  }else{
                       showAlert(strTitle: somethingWentWrongMessage)
                  }
              }
          }
    
    func socialLoginApi(social_id: String, acc_type: String) {
        let prams : [String : Any] = ["social_id": social_id, "acc_type": acc_type]
        self.show()
        api_manager.POSTApi(socialLoginUrl(), param: prams, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    self.setDataInLocal()
                    SaveToDefaults().setUserId(id: self.model?.user_id)
                    SaveToDefaults().setAccessToken(value: self.model?.user_token)
                    self.delegate?.loginSuccess()
                    
                }else if json["statusCode"] == 202{
                    self.setDataInLocal()
                    SaveToDefaults().setUserId(id: self.model?.user_id)
                    SaveToDefaults().setAccessToken(value: self.model?.user_token)
                    self.delegate?.createNewuser()
                } else {
                    showAlert(strTitle: json["statusCode"].string ?? somethingWentWrongMessage)
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
            }
        }
    }
    
}
