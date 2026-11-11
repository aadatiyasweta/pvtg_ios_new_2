//
//  LoginVM.swift
//  PVTG
//
//  Created by Test Machine on 23/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit
protocol AfterLoginSuccess: AnyObject {
    func loginSuccess()
    func failure(msg: String)
    func createNewuser()
    func forgotSuccess()
    func otpCheckSuccess()
    func changePaswdSucces()
    func inCorrectOtpMessage()
    
}
class LoginVM: BaseVm {
    
    //MARK: - Properties
    weak var delegate: AfterLoginSuccess?
    var model: LoginResult?
    
    //MARK: - VALIDATION
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
    
    //MARK: - METHOD TO SETD
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
    
    //MARK: LOGIN API
    func loginApi(email: String, password: String) {
        let prams : [String : Any] = ["email": email, "password": password,"language" : SaveToDefaults().getAppLang() ?? "en"]
        self.show()
        api_manager.POSTApi(loginUrl(), param: prams, header: header()) { (response, err, code) in
            self.dismiss()
//            let cookieHeader = (prams.compactMap({ (key, value) -> String in
//                return "\(key)=\(value)"
//            }) as Array).joined(separator: ";")
//            
//            let loginUrl = String(describing: loginUrl())
//            let responseString = String(describing: response)

            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    let data = try? json["result"].rawData()
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try? jsonDecoder.decode(LoginResult.self, from: data!)
                    self.model = responseModel
                    self.setDataInLocal()
                    SaveToDefaults().setEmail(value: self.model?.email)
                    SaveToDefaults().setUserId(id: self.model?.user_id)
                    SaveToDefaults().setAccessToken(value: self.model?.user_token)
                    self.delegate?.loginSuccess()
                    
                }
                else {
                    self.delegate?.failure(msg: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                   // showAlert(strTitle: cookieHeader + ":: " + loginUrl + ", " + responseString)
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
               // showAlert(strTitle: cookieHeader + ":: " + loginUrl + ", " +  responseString)
            }
           // })
        }
    }
    
    //MARK: - FORGOT PASSWORD API
    func forgotApi(email: String, is_resend: String) {
        let prams : [String : Any] = ["email": email, "is_resend": is_resend,"language" : SaveToDefaults().getAppLang() ?? "en"]
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
    
    //MARK: - OTP API
    func otpCheckApi(email: String, otp: String) {
        let prams : [String : Any] = ["email": email, "otp": otp,"language" : SaveToDefaults().getAppLang() ?? "en"]
           self.show()
        api_manager.GETApi(otpCheckUrl(email: email, otp: otp), param: nil, header: header()) { (response, err, code) in
               self.dismiss()
               if let json = response{
                   debugPrint(json)
                   if json["statusCode"] == 200 {
                       self.delegate?.otpCheckSuccess()
                   }
                   else {
                       if(json["APICODERESULT"].stringValue == "Invalid OTP." || json["APICODERESULT"].stringValue == "Invalid OTP"){
                           self.delegate?.inCorrectOtpMessage()
                       }else{
                           showAlert(strTitle: json["APICODERESULT"].stringValue)
                       }
                   }
               }else{
                   showAlert(strTitle: somethingWentWrongMessage)
               }
           }
       }
    
    //MARK: - CHANGE PASSWORD API
    func changePasswordApi(email: String, password: String) {
           let prams : [String : Any] = ["email": email, "password": password,"language" : SaveToDefaults().getAppLang() ?? "en"]
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
    
    //MARK: - SOCIAL LOGIN API
    func socialLoginApi(social_id: String, acc_type: String, email: String) {
        let prams : [String : Any] = ["social_id": social_id,"email": email, "acc_type": acc_type,"language" : SaveToDefaults().getAppLang() ?? "en"]
        self.show()
        api_manager.POSTApi(socialLoginUrl(), param: prams, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
                //debugPrint(json)
                if json["statusCode"] == 200 {
                    guard let data = try? json["result"].rawData(),
                          let responseModel = try? JSONDecoder().decode(LoginResult.self, from: data) else {
                        showAlert(strTitle: somethingWentWrongMessage)
                        return
                    }
                    self.model = responseModel
                    self.setDataInLocal()
                    SaveToDefaults().setUserId(id: self.model?.user_id)
                    SaveToDefaults().setAccessToken(value: self.model?.user_token)
                    SaveToDefaults().setEmail(value: self.model?.email)
                    self.delegate?.loginSuccess()
                }else if json["statusCode"] == 202 {
                    guard let data = try? json["result"].rawData(),
                          let responseModel = try? JSONDecoder().decode(LoginResult.self, from: data) else {
                        showAlert(strTitle: somethingWentWrongMessage)
                        return
                    }
                    self.model = responseModel
                    self.setDataInLocal()
                    SaveToDefaults().setEmail(value: self.model?.email)
                    SaveToDefaults().setUserId(id: self.model?.user_id)
                    SaveToDefaults().setAccessToken(value: self.model?.user_token)
                    self.delegate?.createNewuser()
                } else {
                    showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
            }
        }
    }
    
}




