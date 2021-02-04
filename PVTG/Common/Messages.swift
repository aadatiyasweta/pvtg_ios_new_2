//


import Foundation
import AVFoundation

let requiredRuleMessage = "This field is required."
let validMobileNumberMessage = "Please enter valid mobile number."
let nameRegex = "[a-z A-Z.]+"
let dateRegex = "^[0-9]{4}-(((0[13578]|(10|12))-(0[1-9]|[1-2][0-9]|3[0-1]))|(02-(0[1-9]|[1-2][0-9]))|((0[469]|11)-(0[1-9]|[1-2][0-9]|30)))$"
let bloodGroupRegex = "(A|B|AB|O|a|b|ab|o)[+-]"
let descriptionRegex = "[a-zA-z0-9]+"
//[789][0-9]{9}
//let mobileNumberRegex = "^(?!0+$)\\d{10,}$"
let mobileNumberRegex = "[789][0-9]{9}"

let emptyOTP = "Enter the OTP"
let emptyNameMessage = "Please enter name."
let emptyconfirmMsg = "*Please enter confirm password"
let matchconfrmpaswdMsg = "*Password and confirm password do not match"
let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
let validBloodGroupMessage = "Please enter valid blood group."
let validEmailMessage = "*Please enter a valid email address."
let emailExistsMessage = "This email-id already exists"
let mobileExistsMessage = "This mobile number already exists"
let passwordRuleMessage = "Please enter valid password."
let emptyPhone = "Please enter phone number."
let validNumber = "*Please enter valid phone Number"
let emptypaswd = "*Please enter password."
let emptyNewpaswd = "*Please enter new password."
let emptyOldPaswd = "Please enter old password"
let emptyStar = "Please rate our services."
let emptyReview = "Please give your feedback."
let invalidPaswd = "*Password should be of atleast 8 character"
let emptyemail = "*Please enter email."
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
let noTeamFound = "You don't have any teams yet."
let emailExistsAsDoctorMessage = "You are already registered with MySwaasth ERP.\n\n\nDo you want to continue with previous account ?"


let serverErrorMessage = "Something went wrong at our end. Don't worry , it's not you it'us Sorry about that."
let internetConnnectionErrorMessage = "Looks like you are not connected with internet.Please check the setting and try again"
let somethingWentWrongMessage = "Something went wrong"
let attributedInternetMessage = AttriButedTextFirstBold("No Internet Connection", .black, getFont(Fonts.bold.rawValue, 18)!, "\n\n \(internetConnnectionErrorMessage)", .black, getFont(Fonts.regular.rawValue, 12)!)

let attributedServerMessage = AttriButedTextFirstBold("Internal Server Error", .black, getFont(Fonts.bold.rawValue, 18)!, "\n\n\(serverErrorMessage)", .black, getFont(Fonts.regular.rawValue, 12)!)

let attributedWentWrongMessage = AttriButedTextFirstBold("Oops!", .black, getFont(Fonts.bold.rawValue, 18)!, "\n\n \(somethingWentWrongMessage)", .black, getFont(Fonts.regular.rawValue, 12)!)

let attributedNoPlayerMessage = AttriButedTextFirstBold("Oops!", .black, getFont(Fonts.bold.rawValue, 18)!, "\n\n \(noPlayerFoundMessage)", .black, getFont(Fonts.regular.rawValue, 12)!)

let attributedNoEventMessage = AttriButedTextFirstBold("Oops!", .black, getFont(Fonts.bold.rawValue, 18)!, "\n\n \(noEventFound)", .black, getFont(Fonts.regular.rawValue, 12)!)



let wentWrongMessage = "Something went wrong please try again."
let noPlayerFoundMessage = "We couldn’t find any players matching your search criteria"
let uploadFailureMessage = ""
let noEventFound  = "We couldn’t find any events matching your search criteria"



let photosPermissionNeededMessage = "Allow MaidnCars to access photos\n\n Note: You won't be able to fetch photos , if denied"
let cameraPermissionNeededMessage = "Allow MaidnCars to access camera\n\n Note: You won't  be able to take photos, if denied"

let locationUnknownErrorMessage = "The location couldn’t be found. This may be because you have not allowed the application to access location information or may be network issues."

let gpsNotEnabledMessage = "The location couldn’t be found. This may be because you have not enabled the location services."

let deniedLocationMessage = "Need location permission to fetch location."
let cannotFetchLocation = "Can not fetch location right now, please try again later."

let internetConnectionMessage = "Your internet connection is not working."

let requiredPinMessage = "Please fill all the fields."
let validPinMessage = "Please enter a valid pin."
let invalidUserMessage = "Invalid user, please login again to continue."
let invalidUsernamePwdMessage = "Invalid Username/Password"
let requiredFieldMessage = "Please fill all the required fields."
let newpinandRepinMessage = "New pin field and re-pin field are not same."
let changePinAlertMessage = "Your pin has been successfully changed."


let invalidDateMessage = "Please enter valid date."
let deleteMemberMessage = "Do you want to delete this member"
let currentPasswordNotMatchedMessage = "Current password is incorrect."
let passwordNotChangedMessage = "Cannot change password right now, try again later."
let bothPassswordsNotMatched = "Both Passwords did not match."
let passwordUpdateAlertMessage = "Do you want to update the saved password?"

