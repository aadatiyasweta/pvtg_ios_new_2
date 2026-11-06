//


import Foundation
import Alamofire
import SwiftyJSON
import SVProgressHUD

extension JSON{
    func isKeyPresent()->Bool {
        if  self.null != nil{
            return false
        }
        return true
    }
}


let api_manager = ApiManager.sharedInstance
class ApiManager {
    
    private init() { }
    static let sharedInstance = ApiManager.init()
    
    func POSTApi(_ url: String, param: [String: Any]?, header : [String : String]?,encoding : ParameterEncoding? = URLEncoding.default,completion:@escaping (_ jsonData:JSON? , _ error:Error?, _ statuscode : Int? )->()) {
        //debugPrint(param ?? [:])
        
        if isConnection(){
            print(logSafe(param))
            DispatchQueue.global(qos: .background).async {
                AF.request(url, method: .post, parameters:param, encoding:encoding!, headers:HTTPHeaders.init(header ?? [:])).validate().response(completionHandler: { dataResponse in
                    DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    //                let respString:String = String(data: (dataResponse.data ?? Data()), encoding: String.Encoding.utf8) ?? ""
                    //                print(respString)
                    //
                    //                let alertViewController = UIAlertController(title: appName, message: respString, preferredStyle: .alert)
                    //                alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
                    //                appDelegate.window?.rootViewController?.present(alertViewController, animated: true, completion: nil)
                    
                    switch dataResponse.result {
                    case .success( let value):
                        let json = JSON.init(value ?? Data())
                        debugPrint(json)
                        if json["statusCode"].isKeyPresent(){
                            if json["statusCode"].intValue == 403{
                                SaveToDefaults().setAccessToken(value: nil)
                                SaveToDefaults().setLogindata(data: Data())
                                defaults.synchronize()
                                //                            let vc = LoginVC.navigation()
                                //                            window?.rootViewController = vc
                                //                            window?.makeKeyAndVisible()
                                appDelegate.setLoginVC()
                            }
                        }
                        // debugPrint(json)
                        completion(json , nil, dataResponse.response?.statusCode)
                    case .failure(let err):
                        completion(nil , err.underlyingError, dataResponse.response?.statusCode)
                    }
                }
            })
        }
        }
        else{
            showMesssgeWindow(msg: internetConnectionMessage)
        }
    }
    
    
    func GETApi(_ url: String, param: [String: Any]?, header : [String : String]?,encoding : ParameterEncoding? = URLEncoding.default,completion:@escaping (_ jsonData:JSON? , _ error:Error?, _ statuscode : Int? )->()) {
        print(logSafe(param))
        if isConnection(){
            DispatchQueue.global(qos: .background).async {
            AF.request(url, method: .get, parameters:param, encoding:encoding!, headers:HTTPHeaders.init(header ?? [:])).validate().response(completionHandler: { dataResponse in
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    let respString:String = String(data: (dataResponse.data ?? Data()), encoding: String.Encoding.utf8) ?? ""
                    print(respString)
                    switch dataResponse.result {
                    case .success( let value):
                        let json = JSON.init(value ?? Data())
                        print(json)
                        if json["statusCode"].isKeyPresent(){
                            if json["statusCode"].intValue == 403{
                                SaveToDefaults().setAccessToken(value: nil)
                                SaveToDefaults().setLogindata(data: Data())
                                defaults.synchronize()
                                //                            let vc = LoginVC.navigation()
                                //                            window?.rootViewController = vc
                                //                            window?.makeKeyAndVisible()
                                appDelegate.setLoginVC()
                            }
                        }
                        completion(json , nil, dataResponse.response?.statusCode)
                    case .failure(let err):
                        completion(nil , err.underlyingError, dataResponse.response?.statusCode)
                    }
                }
            })
        }
    }
        else{
            showMesssgeWindow(msg: internetConnectionMessage)
        }
    }
    
    func PUTApi(_ url: String, param: [String: Any]?, header : [String : String]?,encoding : ParameterEncoding? = URLEncoding.default,completion:@escaping (_ jsonData:JSON? , _ error:Error?, _ statuscode : Int? )->()) {
        print(logSafe(param))
        if isConnection(){
            AF.request(url, method: .put, parameters:param, encoding:encoding!, headers:HTTPHeaders.init(header ?? [:])).validate().response(completionHandler: { dataResponse in
                switch dataResponse.result {
                case .success( let value):
                    let json = JSON.init(value ?? Data())
                    if json["statusCode"].isKeyPresent(){
                        if json["statusCode"].intValue == 403{
                            SaveToDefaults().setAccessToken(value: nil)
                            SaveToDefaults().setLogindata(data: Data())
                            defaults.synchronize()
//                            let vc = LoginVC.navigation()
//                            window?.rootViewController = vc
//                            window?.makeKeyAndVisible()
                            appDelegate.setLoginVC()
                        }
                    }
                    completion(json , nil, dataResponse.response?.statusCode)
                case .failure(let err):
                    debugPrint(err.underlyingError ?? "")
                    completion(nil , err.underlyingError, dataResponse.response?.statusCode)
                }
            })
        }
        else{
            showMesssgeWindow(msg: internetConnectionMessage)
        }
    }
    
    func DeleteApi(_ url: String, param: [String: Any]?, header : [String : String]?,encoding : ParameterEncoding? = URLEncoding.default,completion:@escaping (_ jsonData:JSON? , _ error:Error?, _ statuscode : Int? )->()) {
        print(logSafe(param))
        if isConnection(){
            let head = HTTPHeaders.init(header ?? [:])
            AF.request(url, method: .delete, parameters: param, encoding: encoding!, headers: HTTPHeaders.init(header ?? [:])).validate().response { dataResponse in
                let respString:String = String(data: (dataResponse.data ?? Data()), encoding: String.Encoding.utf8) ?? ""
                print(respString)
                switch dataResponse.result {
                case .success( let value):
                    let json = JSON.init(value ?? Data())
                    completion(json , nil, dataResponse.response?.statusCode)
                case .failure(let err):
                    completion(nil , err.underlyingError, dataResponse.response?.statusCode)
                }
            }
        }else{
            showAlert(strTitle: internetConnectionMessage)
        }
    }
    
    
    func upload(_ url :String , _ data:Data,params : [String:Any]?, _ fileName:String , header:[String:String]? , completion:@escaping (_ error:Error? , _ responce:JSON?,_ statuscode :Int?)->()) {
        if isConnection(){
            let head = HTTPHeaders.init(header ?? [:])
            print(logSafe(params))
            DispatchQueue.global(qos: .background).async {
            AF.upload(multipartFormData: { (multiPart) in
                for (key, value) in params ?? [:] {
                    if let temp = value as? String {
                        multiPart.append(temp.data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? Int {
                        multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key + "[]"
                            if let string = element as? String {
                                multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
                multiPart.append(data, withName: fileName, fileName: "file.png", mimeType: "image/png")
            }, to: url, method: .post, headers: head).response{ (response) in
                SVProgressHUD.dismiss()
                let respString:String = String(data: (response.data ?? Data()), encoding: String.Encoding.utf8) ?? ""
                print(respString)
                DispatchQueue.main.async {
                switch response.result{
                case .success(let data):
                    let json = JSON.init(data ?? Data())
                    if json["statusCode"].isKeyPresent(){
                        if json["statusCode"].intValue == 403{
                            SaveToDefaults().setAccessToken(value: nil)
                            SaveToDefaults().setLogindata(data: Data())
                            defaults.synchronize()
                            //                                    let vc = LoginVC.navigation()
                            //                                    window?.rootViewController = vc
                            //                                    window?.makeKeyAndVisible()
                            appDelegate.setLoginVC()
                        }
                    }
                    completion(nil , json, response.response?.statusCode)
                case .failure(let err):
                    completion(err.underlyingError , nil, response.response?.statusCode)
                }
            }
            }
        }
    }
                else{
                    showAlert(strTitle: internetConnectionMessage)
                }
            }
}


