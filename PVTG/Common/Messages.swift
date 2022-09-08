//


import Foundation
import AVFoundation

let nameRegex = "[a-z A-Z.]+"
let dateRegex = "^[0-9]{4}-(((0[13578]|(10|12))-(0[1-9]|[1-2][0-9]|3[0-1]))|(02-(0[1-9]|[1-2][0-9]))|((0[469]|11)-(0[1-9]|[1-2][0-9]|30)))$"
let bloodGroupRegex = "(A|B|AB|O|a|b|ab|o)[+-]"
let descriptionRegex = "[a-zA-z0-9]+"
//[789][0-9]{9}
//let mobileNumberRegex = "^(?!0+$)\\d{10,}$"
let mobileNumberRegex = "[789][0-9]{9}"

let emptyOTP = R.string.localizable.emptyOTP()
let emptyNameMessage = R.string.localizable.emptyNameMessage()
let emptyconfirmMsg = R.string.localizable.emptyconfirmMsg()
let matchconfrmpaswdMsg = R.string.localizable.matchconfrmpaswdMsg()
let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
let validEmailMessage = R.string.localizable.validEmailMessage()
let emailExistsMessage =  R.string.localizable.emailExistsMessage()
let mobileExistsMessage =  R.string.localizable.mobileExistsMessage()
let passwordRuleMessage =  R.string.localizable.passwordRuleMessage()
let emptyPhone = R.string.localizable.emptyPhone()
let validNumber = R.string.localizable.validNumber()
let emptypaswd = R.string.localizable.emptypaswd()
let emptyNewpaswd = R.string.localizable.emptyNewpaswd()
let emptyOldPaswd = R.string.localizable.emptyOldPaswd()
let emptyStar = R.string.localizable.emptyStar()
let emptyReview = R.string.localizable.emptyReview()
let invalidPaswd = R.string.localizable.invalidPaswd()
let emptyemail = R.string.localizable.emptyemail()
let minPasswordRuleMessage = "Please enter minimum \(minimumPasswordLength) characters."
let maxPasswordRuleMessage = "Please enter maximum \(maximumPasswordLength) characters."
let minimumPasswordLength = 6
let maximumPasswordLength = 20
let minNameRuleMessage = "Please enter minimum \(minNameLength) characters."
let maxNameRuleMessage = "Please enter maximum \(maxNameLength) characters."
let minNameLength = 2
let maxNameLength = 30
let otpVerifiedMessage = "Enter valid OTP"

let cannotSendOtpToMobileMessage = "Cannot send otp to this number"
let otpSendSuccessMessage = "OTP has been successfully sent to your number"
let otpCallSuccessMessage = "You will receive a call in just 3 second"
let otpSendFailedMessage = "Cannot send otp this time , try again later"
let otpCallFailedMessage = "Cannot send otp via call this time , try again later"
let enterRegisteredMobileNUmber = "Please enter your registered mobile number."
let confirmPasswordMessage = "You must enter the same password twice in order to confirm it!!!"
let serverErrorMessage = "Something went wrong at our end. Don't worry , it's not you it'us Sorry about that."
let internetConnnectionErrorMessage = "Looks like you are not connected with internet.Please check the setting and try again"
let somethingWentWrongMessage = "Something went wrong"
let attributedInternetMessage = AttriButedTextFirstBold("No Internet Connection", .black, getFont(Fonts.bold.rawValue, 18)!, "\n\n \(internetConnnectionErrorMessage)", .black, getFont(Fonts.regular.rawValue, 12)!)
let attributedServerMessage = AttriButedTextFirstBold("Internal Server Error", .black, getFont(Fonts.bold.rawValue, 18)!, "\n\n\(serverErrorMessage)", .black, getFont(Fonts.regular.rawValue, 12)!)
let wentWrongMessage = "Something went wrong please try again."
let photosPermissionNeededMessage = "Allow MaidnCars to access photos\n\n Note: You won't be able to fetch photos , if denied"
let cameraPermissionNeededMessage = "Allow MaidnCars to access camera\n\n Note: You won't  be able to take photos, if denied"
let locationUnknownErrorMessage = "The location couldn’t be found. This may be because you have not allowed the application to access location information or may be network issues."
let gpsNotEnabledMessage = "The location couldn’t be found. This may be because you have not enabled the location services."
let deniedLocationMessage = "Need location permission to fetch location."
let cannotFetchLocation = "Can not fetch location right now, please try again later."
let internetConnectionMessage = "Your internet connection is not working."








