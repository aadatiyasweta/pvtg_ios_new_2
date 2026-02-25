
import Foundation
import UIKit


// for test -development
//let topSearch = "https://techugoserver.info/pvtg_dev/admin_assets/img/topsearch.png" // new dev url
//let testingServer = "https://techugoserver.info/pvtg_dev/api/v1/" // new development url - 2025
//let stripePaymentAPI = "https://techugoserver.info/pvtg_dev/public/Stripe_IOS/stripe_payment.php" // new development
//let stripeTestPublishableKey = "pk_test_51KLVfEFKDEQWO0TJyXCr934HPHv6W2pl1kBJiVZnYBIti9OXCMbt3gt5Wzen5wg2tRaCikH81qLI2TFiAMH5WLSf009SjBYjnl" // for test
//let stripeSecretKey = "sk_test_51KLVfEFKDEQWO0TJrKqJfkq4CRtvcEwStccSrsYhM8tWaFxNAfX7VcepIXpbcUA0xAbPlReKxnuCcZEnFc9M5Uhd00PrDGpCFT" // for test
//
//let terms =  "https://techugoserver.info/pvtg_dev/terms_condition.html"
//let aboutUs = "https://techugoserver.info/pvtg_dev/about_us.html"
//let faq = "https://techugoserver.info/pvtg_dev/faq.html"
//let privacy = "https://techugoserver.info/pvtg_dev/privacy_policy.html"
//let cancelPolicy = "https://techugoserver.info/pvtg_dev/cancel_policy.html" // development
//


// for live -
let topSearch = "https://dharma.services/admin_assets/img/topsearch.png" // new Live url
let testingServer = "https://dharma.services/api/v1/" // live
let stripePaymentAPI = "https://dharma.services/public/Stripe_IOS/stripe_payment.php" // live
let stripeLivePublishKey = "pk_live_51KLVfEFKDEQWO0TJD37bD6aaeD9D0zRixYanno17NoNB2anCHC3P6zwJLq5BH1b97XFX0M0RnC3nIPewmbNMb6Mi00H8JNUV0H" // dfor live
let stripeLiveSecretKey = "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" // for live

let terms =  "https://dharma.services/terms_condition.html"
let aboutUs = "https://dharma.services/about_us.html"
let faq = "https://dharma.services/faq.html"
let privacy = "https://dharma.services/privacy_policy.html"
let cancelPolicy = "https://dharma.services/cancel_policy.html" // live




let stripeRefundAPI = "https://api.stripe.com/v1/refunds"


//let server = testingServer
let server = Config.shared.baseUrl()
let googlePlacesSearchApi = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=noida&key=AIzaSyC6hyx1WnYOhTnbbvdYR-f7nWvVqyHgn2k"
let appLanguage = SaveToDefaults().getAppLang() ?? "en"
func loginUrl()-> String {
    var  url = "\(server)Userapi/normal_login"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Userapi/normal_login",url)
    return url
}

//var AppObject:AppDelegate
//{
//    return UIApplication.shared.delegate as! AppDelegate
//}

var SCREENSIZE:CGSize
{
    return UIScreen.main.bounds.size
}

func forgotUrl()-> String {
    var  url = "\(server)Userapi/forgot"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Userapi/forgot",url)
    return url
}
func otpCheckUrl(email:String, otp: String)-> String {
//    var  url = "http://54.245.144.158/pvtg_dev/api/v1/Userapi/check_otp?email=\(email)&otp=\(otp)&language=\(SaveToDefaults().getAppLang() ?? "en")" // old development url
    
    
//    var  url = "https://techugoserver.info/pvtg_dev/api/v1/Userapi/check_otp?email=\(email)&otp=\(otp)&language=\(SaveToDefaults().getAppLang() ?? "en")" // new test url
    
    var  url = "https://dharma.services/api/v1/Userapi/check_otp?email=\(email)&otp=\(otp)&language=\(SaveToDefaults().getAppLang() ?? "en")" // new live url
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Userapi/check_otp",url)
    return url
}
func resetPasswordUrl()-> String {
    var  url = "\(server)Userapi/reset_password"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Userapi/reset_password",url)
    return url
}

func registrationUrl()-> String {
    var  url = "\(server)Userapi/signup"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Userapi/signup",url)
    return url
}
func checkEmailPhoneUrl()-> String {
    var  url = "\(server)Userapi/check_email_phone"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Userapi/check_email_phone",url)
    return url
}
func socialLoginUrl()-> String {
    var  url = "\(server)Userapi/social_login"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Userapi/social_login",url)
    return url
}
func logOutUrl()-> String {
    var  url = "\(server)Userapi/logout?language=\(SaveToDefaults().getAppLang() ?? "en")"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Userapi/logout",url)
    return url
}
func changePasswordUrl()-> String {
    var  url = "\(server)Userapi/change_password"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Userapi/change_password",url)
    return url
}
func checkSession()-> String{
    var  url = "\(server)Sessionapi/check_session"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Sessionapi/check_session",url)
    return url
}
func togglePushUrl()-> String {
    var  url = "\(server)togglePush"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("togglePush",url)
    return url
}
func getProfileUrl()-> String {
    var  url = "\(server)getmyProfile"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("getmyProfile",url)
    return url
}
func editProfileUrl()-> String {
    var  url = "\(server)Userapi/update_user_profile"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Userapi/update_user_profile",url)
    return url
}
func gethome()-> String {
    var  url = "\(server)Sessionapi/home"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("gethome",url)
    return url
}
func sessionDetailApi()-> String {
    var  url = "\(server)Sessionapi/session_detail"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Sessionapi/session_detail",url)
    return url
}
///
func check_ticketApi(user_id: String, ticket: String, schedule_time_id: String)-> String {
    var  url = "\(server)Sessionapi/check_ticket?user_id=\(user_id)&ticket=\(ticket)&schedule_time_id=\(schedule_time_id)&language=\(SaveToDefaults().getAppLang() ?? "en")"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Sessionapi/check_ticket",url)
    return url
}
//
func ticketDataApi(user_id: String, session_id: String, schedule_time_id: String)-> String {
    var  url = "\(server)Sessionapi/ticket_data?user_id=\(user_id)&session_id=\(session_id)&schedule_time_id=\(schedule_time_id)&language=\(SaveToDefaults().getAppLang() ?? "en")"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Sessionapi/ticket_data",url)
    return url
}
//
func activeEventApi()-> String {
    var  url = "\(server)Sessionapi/active_event?language=\(SaveToDefaults().getAppLang() ?? "en")"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Sessionapi/active_event",url)
    return url
}
///
func historySessionApi()-> String {
    var  url = "\(server)Sessionapi/history_event?language=\(SaveToDefaults().getAppLang() ?? "en")"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Sessionapi/history_event",url)
    return url
}
///
func user_profileApi()-> String {
    var  url = "\(server)Userapi/user_profile?language=\(SaveToDefaults().getAppLang() ?? "en")"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Userapi/user_profile",url)
    return url
}
///language=\(SaveToDefaults().getAppLang() ?? "en")
func updateProfileUrl()-> String {
    var  url = "\(server)Userapi/update_user_profile"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Userapi/update_user_profile",url)
    return url
}
func sessionRatingUrl()-> String {
    var  url = "\(server)Sessionapi/session_rating"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Userapi/session_rating",url)
    return url
}

func updateDeviceTokenUrl()-> String {
    var  url = "\(server)Userapi/update_device_token"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("updateDeviceTokenUrl",url)
    return url
}

func deleteAccountUrl()-> String {
    var  url = "\(server)Userapi/delete_account"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("deleteAccountUrl",url)
    return url
}

func removeProfilePicUrl()-> String {
    var  url = "\(server)Userapi/remove_profile_pic"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("removeProfilePicUrl",url)
    return url
}


func changeLanguageUrl()-> String {
    var  url = "\(server)Userapi/change_language"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("changeLanguageUrl",url)
    return url
}


func session_time_detail()-> String {
    var  url = "\(server)Sessionapi/session_time_detail"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Sessionapi/session_time_detail",url)
    return url
}
///
func reviewUser()-> String {
    var  url = "\(server)reviewUser?anguage=\(SaveToDefaults().getAppLang() ?? "en")"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("reviewUser",url)
    return url
}
func getCoachNotificationList()-> String {
    var  url = "\(server)Userapi/notification_list?language=\(SaveToDefaults().getAppLang() ?? "en")"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Userapi/notification_list",url)
    return url
}
func searchPlacesApi(text: String)-> String {
    var  url = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(text)&key=AIzaSyC6hyx1WnYOhTnbbvdYR-f7nWvVqyHgn2k"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("googlePlacesSearchApi",url)
    return url

}
func allCategoryUrl(userid: String)-> String {
    var  url = "\(server)Userapi/all_category?user_id=\(userid)"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print(" Userapi/all_categoryUrl",url)
    return url
}
//&language=\(SaveToDefaults().getAppLang() ?? "en")
func searchSessionUrl()-> String {
    var  url = "\(server)Sessionapi/search?language=\(SaveToDefaults().getAppLang() ?? "en")"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Sessionapi/search",url)
    return url
}
func sessionallCategoryUrl()-> String {
    var  url = "\(server)Sessionapi/all_category"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Sessionapi/all_category",url)
    return url
}
///language=\(SaveToDefaults().getAppLang() ?? "en")
func sessionBookingUrl()-> String {
    var  url = "\(server)Sessionapi/session_booking"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Sessionapi/session_booking",url)
    return url
}

func selectInterestUrl()-> String{
    var  url = "\(server)Userapi/user_interest_category"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Userapi/user_interest_category",url)
    return url
}
func getSplashPointsUrl()-> String{
    var  url = "\(server)Userapi/getSplashPoints?language=\(SaveToDefaults().getAppLang() ?? "en")"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("getSplashPointsUrl",url)
    return url
}
func getCurrencyDataUrl(id:String)-> String{
    var  url = "\(server)Sessionapi/get_currency?user_id=\(id)&language=\(SaveToDefaults().getAppLang() ?? "en")"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("getCurrencyDataUrl",url)
    return url
}

func getPrefrenceIdUrl()-> String{
    var  url = "https://api.mercadopago.com/checkout/preferences"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("getPrefrenceIdUrl",url)
    return url
    
}

func rescheduleSessionApiUrl()-> String{
    var  url = "\(server)Sessionapi/session_booking_reschedule"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("rescheduleSessionApiUrl",url)
    return url
}

func contactUsApiUrl()-> String{
    var  url = "\(server)Sessionapi/contact_us"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("contactUsApiUrl",url)
    return url
}


func sessionCancelApiUrl()-> String{
    var  url = "\(server)Sessionapi/session_cancellation"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("sessionCancelApiUrl",url)
    return url
}
func partialRefundApiUrl()-> String{
    var  url = "\(server)Sessionapi/mecardo_partial_payment"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("partialRefundApiUrl",url)
    return url
}
func fullRefundApiUrl()-> String{
    var  url = "\(server)Sessionapi/mecardo_payment_refund"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("fullRefundApiUrl",url)
    return url
}
func attendingSession()-> String{
    var  url = "\(server)Sessionapi/confirm_booking"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("attendingSession",url)
    return url
}

func makePaymentUsingStripe()-> String{
    var  url = stripePaymentAPI
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("makePayment",url)
    return url
}

func refundPaymentUsingStripe()-> String{
    var  url = stripeRefundAPI
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("refundPayment",url)
    return url
}

func getAllPaymentDetailsUrl(user_id: String)-> String{
    var  url = "\(server)Userapi/all_payments?user_id=\(user_id)"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("getAllPayments",url)
    return url
}

func updateNotificationStatusUrl()-> String{
    var  url = "\(server)Userapi/update_read_status"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Userapi/user_interest_category",url)
    return url
}
