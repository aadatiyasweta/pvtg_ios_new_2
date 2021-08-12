//
//

import Foundation
import UIKit

let more = UIStoryboard.init(name: "More", bundle: nil)
let login = UIStoryboard.init(name: "Login", bundle: nil)
let home = UIStoryboard.init(name: "Home", bundle: nil)
let main = UIStoryboard.init(name: "Main", bundle: nil)
let setting = UIStoryboard.init(name: "Setting", bundle: nil)
let session = UIStoryboard.init(name: "Session", bundle: nil)
let profile = UIStoryboard.init(name: "Profile", bundle: nil)
let onboarding = UIStoryboard.init(name: "Onboarding", bundle: nil)
let splash = UIStoryboard.init(name: "Onboarding", bundle: nil)

extension OnboardingVC {
    class func instance()-> OnboardingVC {
           return onboarding.instantiateViewController(withIdentifier: "OnboardingVC") as! OnboardingVC
       }
    class func navigation()-> UINavigationController{
           return onboarding.instantiateViewController(withIdentifier: "onboarding") as! UINavigationController
       }
}
extension LanguageChnageVC {
    class func instance()-> LanguageChnageVC {
           return onboarding.instantiateViewController(withIdentifier: "LanguageChnageVC") as! LanguageChnageVC
       }
    class func navigation()-> UINavigationController{
           return onboarding.instantiateViewController(withIdentifier: "lang") as! UINavigationController
       }
}

extension SplashVC {
    class func instance()-> SplashVC {
           return onboarding.instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
       }
    class func navigation()-> UINavigationController{
           return onboarding.instantiateViewController(withIdentifier: "splash") as! UINavigationController
       }
}
extension LoginVC {
    class func instance()-> LoginVC {
           return login.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
       }
    class func navigation()-> UINavigationController{
           return login.instantiateViewController(withIdentifier: "login") as! UINavigationController
       }
}
extension RegistrationvC {
    class func instance()-> RegistrationvC {
           return login.instantiateViewController(withIdentifier: "RegistrationvC") as! RegistrationvC
       }
}
extension ForgotPaswordVC {
    class func instance()-> ForgotPaswordVC {
              return login.instantiateViewController(withIdentifier: "ForgotPaswordVC") as! ForgotPaswordVC
          }
}
extension OTPVC {
    class func instance()-> OTPVC {
              return login.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
          }
}
extension ChangepaswdVC {
    class func instance()-> ChangepaswdVC {
              return login.instantiateViewController(withIdentifier: "ChangepaswdVC") as! ChangepaswdVC
          }
}

extension EventsViewController {
    class func instance()-> EventsViewController {
        return home.instantiateViewController(withIdentifier: "EventsViewController") as! EventsViewController
    }
}

extension HoliosticGuideVC {
    class func instance()-> HoliosticGuideVC {
        return home.instantiateViewController(withIdentifier: "HoliosticGuideVC") as! HoliosticGuideVC
    }
}

extension TransformerExampleViewController {
    class func instance()-> TransformerExampleViewController {
        return home.instantiateViewController(withIdentifier: "TransformerExampleViewController") as! TransformerExampleViewController
    }
}

/*extension InterestVC {
    class func instance()-> InterestVC {
        return home.instantiateViewController(withIdentifier: "InterestVC") as! InterestVC
    }
}*/


extension MoreVC {
    class func instance()-> MoreVC {
        return home.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
    }
}

extension HomeViewController {
    class func instance()-> HomeViewController {
        return home.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    }
}
extension SummaryVC {
    class func instance()-> SummaryVC {
        return home.instantiateViewController(withIdentifier: "SummaryVC") as! SummaryVC
    }

}
extension TabBarControllerViewController {
    class func navigation()-> UINavigationController{
           return home.instantiateViewController(withIdentifier: "home") as! UINavigationController
       }
    class func instance()-> TabBarControllerViewController {
        return home.instantiateViewController(withIdentifier: "TabBarControllerViewController") as! TabBarControllerViewController
    }

}

extension PrivacyPolicyVC {
    class func instance()-> PrivacyPolicyVC {
        return more.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
    }
}
extension FaqSupport_VC {
    class func instance()-> FaqSupport_VC {
        return more.instantiateViewController(withIdentifier: "FaqSupport_VC") as! FaqSupport_VC
    }
}
extension ChangePasswordVC {
    class func instance()-> ChangePasswordVC {
        return more.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
    }
}

extension SearchSessionVC {
    class func navigation()-> UINavigationController{
        return session.instantiateViewController(withIdentifier: "session") as! UINavigationController
    }
    class func instance()-> SearchSessionVC {
        return session.instantiateViewController(withIdentifier: "SearchSessionVC") as! SearchSessionVC
    }
}

extension SessionDetailVC {
    class func instance()-> SessionDetailVC {
        return session.instantiateViewController(withIdentifier: "SessionDetailVC") as! SessionDetailVC
    }
}

extension ProfileVC {
    class func instance()-> ProfileVC {
        return profile.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
    }
}

extension RateUsVC {
    class func instance()-> RateUsVC {
           return profile.instantiateViewController(withIdentifier: "RateUsVC") as! RateUsVC
       }
}

extension ThankyouVC {
    class func instance()-> ThankyouVC {
           return profile.instantiateViewController(withIdentifier: "ThankyouVC") as! ThankyouVC
       }
}

extension NotificationVC {
    class func instance()-> NotificationVC {
           return profile.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
       }
}
extension EditProfileVC {
    class func instance()-> EditProfileVC {
              return profile.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
          }
}

extension SearchLocationVC {
    class func instance()-> SearchLocationVC {
        return profile.instantiateViewController(withIdentifier: "SearchLocationVC") as! SearchLocationVC
    }
}
