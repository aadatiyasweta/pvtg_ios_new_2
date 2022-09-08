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
            loginManager.logIn(permissions: ["email","public_profile"], from: UIViewController(), handler: { (result, error) -> Void in
                
                if (error == nil)
                {
                    let fbloginresult : LoginManagerLoginResult = result!
                    if(fbloginresult.isCancelled)
                    {
                        print("FB login canceled")
                        if let delegate = self.delegate
                        {
                            delegate.fbLoginCancelled()
                        }
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
        }
        else
        {
        }
        }
    
    func getUserInformation()
    {
    }
    
    func getFacebookFriends(userId:String)
    {
    }
}

