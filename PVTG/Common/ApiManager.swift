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

    private var isHandlingSessionExpiry = false

    private func isAuthUrl(_ url: String) -> Bool {
        return [loginUrl(), socialLoginUrl(), registrationUrl(), forgotUrl()].contains(url)
    }

    private func handleSessionExpiryIfNeeded(url: String, httpCode: Int?, data: Data?) -> Bool {
        if isAuthUrl(url) { return false }
        let bodyCode = JSON(data ?? Data())["statusCode"].int
        let expired = httpCode == 401 || httpCode == 403 || bodyCode == 401 || bodyCode == 403
        guard expired else { return false }
        if isHandlingSessionExpiry { return true }
        guard SaveToDefaults().getAccessToken() != nil else { return false }

        isHandlingSessionExpiry = true
        SVProgressHUD.dismiss()
        SaveToDefaults().setAccessToken(value: nil)
        SaveToDefaults().setLogindata(data: Data())
        defaults.synchronize()
        appDelegate.setLoginVC()
        showAlert(strTitle: sessionExpiredMessage)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isHandlingSessionExpiry = false
        }
        return true
    }

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

                    if self.handleSessionExpiryIfNeeded(url: url, httpCode: dataResponse.response?.statusCode, data: dataResponse.data) { return }
                    switch dataResponse.result {
                    case .success( let value):
                        let json = JSON.init(value ?? Data())
                        debugPrint(json)
                        completion(json , nil, dataResponse.response?.statusCode)
                    case .failure(let err):
                        completion(nil , err.underlyingError ?? err, dataResponse.response?.statusCode)
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
                    if self.handleSessionExpiryIfNeeded(url: url, httpCode: dataResponse.response?.statusCode, data: dataResponse.data) { return }
                    switch dataResponse.result {
                    case .success( let value):
                        let json = JSON.init(value ?? Data())
                        print(json)
                        completion(json , nil, dataResponse.response?.statusCode)
                    case .failure(let err):
                        completion(nil , err.underlyingError ?? err, dataResponse.response?.statusCode)
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
                DispatchQueue.main.async {
                    if self.handleSessionExpiryIfNeeded(url: url, httpCode: dataResponse.response?.statusCode, data: dataResponse.data) { return }
                    switch dataResponse.result {
                    case .success( let value):
                        let json = JSON.init(value ?? Data())
                        completion(json , nil, dataResponse.response?.statusCode)
                    case .failure(let err):
                        debugPrint(err.underlyingError ?? err)
                        completion(nil , err.underlyingError ?? err, dataResponse.response?.statusCode)
                    }
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
                DispatchQueue.main.async {
                    let respString:String = String(data: (dataResponse.data ?? Data()), encoding: String.Encoding.utf8) ?? ""
                    print(respString)
                    if self.handleSessionExpiryIfNeeded(url: url, httpCode: dataResponse.response?.statusCode, data: dataResponse.data) { return }
                    switch dataResponse.result {
                    case .success( let value):
                        let json = JSON.init(value ?? Data())
                        completion(json , nil, dataResponse.response?.statusCode)
                    case .failure(let err):
                        completion(nil , err.underlyingError ?? err, dataResponse.response?.statusCode)
                    }
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
                if self.handleSessionExpiryIfNeeded(url: url, httpCode: response.response?.statusCode, data: response.data) { return }
                switch response.result{
                case .success(let data):
                    let json = JSON.init(data ?? Data())
                    completion(nil , json, response.response?.statusCode)
                case .failure(let err):
                    completion(err.underlyingError ?? err , nil, response.response?.statusCode)
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


