import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
//import Bolts

protocol FacebookDelegate
{
    func fbLoginSuccess()
    func fbLoginFail(error:NSError)
    func fbLoginCancelled()
    
    func fbUserInfoSuccess(result:AnyObject)
    func fbUserInfoFail(err:NSError)
}

class Facebook: NSObject
{
     var delegate: FacebookDelegate?
    
    func isFbLogin()->Bool
    {
        if (AccessToken .current != nil)
        {
                return true
        }
        return false
    }
    
    func doLogout()
    {
        LoginManager().logOut()
    }
    
    func doLoginWithFacebook()
    {
        if (AccessToken .current == nil)
        {
          self.doLoginWithReadPermission()
        }
        else
        {
            // user is already logged in
            if let delegate = self.delegate
            {
                delegate.fbLoginSuccess()
            }
        }
    }
    
    func doLoginWithReadPermission()
    {
        if (AccessToken .current == nil)
        {
            let loginManager = LoginManager()
            
//            loginManager.loginBehavior = .native
            loginManager.logIn(permissions: ["email","public_profile"], from: UIViewController(), handler: { (result, error) -> Void in
                
                if (error == nil)
                {
                    let fbloginresult : LoginManagerLoginResult = result!
                    if(fbloginresult.isCancelled)
                    {
                        print("FB login canceled")
                        // user is already logged in
                        if let delegate = self.delegate
                        {
                            delegate.fbLoginCancelled()
                        }
                        // Handle cancellations
                        //Show Cancel alert
                    }
                  
                    else if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        
                       self.getUserInformation()
                    }
                   
                }
                else
                {
                    // Process error
                    print("Fb login error occured =%@",error ?? "")
                    if let delegate = self.delegate
                    {
                        delegate.fbLoginFail(error: error! as NSError)
                    }
                }
            })
//            loginManager.logIn(withReadPermissions: ["email","public_profile"], handler: { (result, error) -> Void in
//
//                if (error == nil)
//                {
//                    let fbloginresult : FBSDKLoginManagerLoginResult = result!
//                    if(fbloginresult.isCancelled)
//                    {
//                        print("FB login canceled")
//                        // user is already logged in
//                        if let delegate = self.delegate
//                        {
//                            delegate.fbLoginCancelled()
//                        }
//                        // Handle cancellations
//                        //Show Cancel alert
//                    }
//
//                    else if(fbloginresult.grantedPermissions.contains("email"))
//                    {
//
//                       self.getUserInformation()
//                    }
//
//                }
//                else
//                {
//                    // Process error
//                    print("Fb login error occured =%@",error ?? "")
//                    if let delegate = self.delegate
//                    {
//                        delegate.fbLoginFail(error: error! as NSError)
//                    }
//                }
//            })
        }
        else
        {
            //user is already logged in
        }
        }
    
    
    func getUserInformation()
    {
        if((AccessToken.current) != nil)
        {
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, gender, picture,email,friends"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil)
                {
                    print("Facebook user details fetched")
                    if let delegate = self.delegate
                    {
                        delegate.fbUserInfoSuccess(result: result as AnyObject)
                        let id = (result as! NSDictionary).object(forKey: "id")
                        self.getFacebookFriends(userId: id as! String)
                        
                    }

                }
                else
                {
                    if let delegate = self.delegate
                    {
                        delegate.fbUserInfoFail(err: error! as NSError)
                    }
                }
            })
           
        }
    }
    
    func getFacebookFriends(userId:String)
    {

    }
    
    
    
}

