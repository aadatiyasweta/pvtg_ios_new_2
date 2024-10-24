//
//  ProfileViewModel.swift
//  PVTG
//
//  Created by Test Machine on 15/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit

protocol UpdateTheProfile: AnyObject {
    func updateProfile()
    func removeProfilePic()
}

class ProfileViewModel: BaseVm {
    
    //MARK: - Propertoes
    var model: ProfileResult?
    weak var delegate: UpdateTheProfile?
    
    //MARK: - METHOD TO SET DATA IN LOCAL
    func setDataInLocal(){
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(self.model) {
            SaveToDefaults().setLogindata(data: encodedData)
        }
        defaults.synchronize()
    }
    
    //MARK: - METHOD TO GET DATA FROM LOCAL
    func getDataFromLocal()->ProfileResult?{
        if let decodedData  = SaveToDefaults().getLoginData(){
            let decoder = JSONDecoder()
            if let model = try? decoder.decode(ProfileResult.self, from: decodedData) {
                self.model = model
                return model
            }
        }
        return nil
    }
    
    //MARK: - GET USER PROFILE API METHOD
    func getUserProfileApi(user_id: String) {
        let prams : [String : Any] = ["user_id": user_id,"language" : SaveToDefaults().getAppLang() ?? "en"]
        self.show()
        api_manager.GETApi(user_profileApi(), param: prams, header: header()) { (response, err, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    let data = try? json["result"].rawData()
                    let jsonDecoder = JSONDecoder()
                    let model = try? jsonDecoder.decode(ProfileResult.self, from: data ?? Data())
                    self.setDataInLocal()
                    self.model = model
                    SaveToDefaults().setEmail(value: self.model?.user_profile?.email)
                    self.delegate?.updateProfile()
                }
                else {
                    showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
            }
        }
    }
    
    //MARK: - UPDATE PROFILE API METHOD
    func updateProfileApi(user_id: String, image: Data, email: String, country_code: String, phone: String, name: String){
        let prams : [String : Any] = ["user_id": user_id, "image": image, "email": email, "country_code": country_code, "phone": phone, "name": name,"language" : SaveToDefaults().getAppLang() ?? "en"]
        self.show()
        var key = "image"
        if image.count == 0{
            key = ""
        }
        api_manager.upload(editProfileUrl(), image, params: prams, key, header: header()){ (err,response, code) in
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    SaveToDefaults().setProfilePic(value:  json["result"]["user_image"].stringValue)
                    self.delegate?.updateProfile()
                }
                else {
                    showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
            }
        }
    }
    
    func removeProfilePicApi(isDelete : Bool? = false){
        let param : [String:Any] = [
            "user_id" : SaveToDefaults().getUserId() ?? "",
            "language" : SaveToDefaults().getAppLang() ?? "en"
        ]
        print(header() ?? [:])
        self.show()
        api_manager.PUTApi(removeProfilePicUrl(), param: param, header: header()) { (response, err, stausCode) in
            
            self.dismiss()
            if let json = response{
                debugPrint(json)
                if json["statusCode"] == 200 {
                    self.delegate?.removeProfilePic()
                    showAlert(strTitle: json["APICODERESULT"].string ?? "Profile pic removed successfully.")
                }
                else {
                    showAlert(strTitle: json["APICODERESULT"].string ?? somethingWentWrongMessage)
                }
            }else{
                showAlert(strTitle: somethingWentWrongMessage)
            }
        }
    }
}
