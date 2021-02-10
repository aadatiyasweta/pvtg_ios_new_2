
import Foundation
import UIKit


let topSearch = "http://52.27.53.102/pvtg/admin_assets/img/topsearch.png"
let testingServer = "http://52.27.53.102/pvtg/api/v1/"
let terms =  "http://52.27.53.102/pvtg/terms_condition.html"
let aboutUs = "http://52.27.53.102/pvtg/about_us.html"
let faq = "http://52.27.53.102/pvtg/faq.html"
let privacy = "http://52.27.53.102/pvtg/privacy_policy.html"
let server = testingServer
let googlePlacesSearchApi = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=noida&key=AIzaSyC6hyx1WnYOhTnbbvdYR-f7nWvVqyHgn2k"

func loginUrl()-> String {
    var  url = "\(server)Userapi/normal_login"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Userapi/normal_login",url)
    return url
}
func forgotUrl()-> String {
    var  url = "\(server)Userapi/forgot"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Userapi/forgot",url)
    return url
}
func otpCheckUrl(email:String, otp: String)-> String {
    var  url = "http://52.27.53.102/pvtg/api/v1/Userapi/check_otp?email=\(email)&otp=\(otp)"
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
    var  url = "\(server)Userapi/logout"
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
func check_ticketApi(user_id: String, ticket: String, schedule_time_id: String)-> String {
    var  url = "http://52.27.53.102/pvtg/api/v1/Sessionapi/check_ticket?user_id=\(user_id)&ticket=\(ticket)&schedule_time_id=\(schedule_time_id)"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Sessionapi/check_ticket",url)
    return url
}

func ticketDataApi(user_id: String, session_id: String, schedule_time_id: String)-> String {
    var  url = "http://52.27.53.102/pvtg/api/v1/Sessionapi/ticket_data?user_id=\(user_id)&session_id=\(session_id)&schedule_time_id=\(schedule_time_id)"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Sessionapi/ticket_data",url)
    return url
}
func activeEventApi()-> String {
    var  url = "\(server)Sessionapi/active_event"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Sessionapi/active_event",url)
    return url
}
func historySessionApi()-> String {
    var  url = "\(server)Sessionapi/history_event"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Sessionapi/history_event",url)
    return url
}
func user_profileApi()-> String {
    var  url = "\(server)Userapi/user_profile"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Userapi/user_profile",url)
    return url
}
func updateProfileUrl()-> String {
    var  url = "\(server)Userapi/update_user_profile"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Userapi/update_user_profile",url)
    return url
}
func sessionRatingUrl()-> String {
    var  url = "\(testingServer)Sessionapi/session_rating"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Userapi/session_rating",url)
    return url
}

func updateDeviceTokenUrl()-> String {
    var  url = "\(testingServer)Userapi/update_device_token"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("updateDeviceTokenUrl",url)
    return url
}

func session_time_detail()-> String {
    var  url = "\(testingServer)Sessionapi/session_time_detail"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Sessionapi/session_time_detail",url)
    return url
}
func reviewUser()-> String {
    var  url = "\(server)reviewUser"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("reviewUser",url)
    return url
}
func getCoachNotificationList()-> String {
    var  url = "\(server)Userapi/notification_list"
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
    var  url = "http://52.27.53.102/pvtg/api/v1/Userapi/all_category?user_id=\(userid)"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print(" Userapi/all_categoryUrl",url)
    return url
}
func searchSessionUrl()-> String {
    var  url = "\(testingServer)Sessionapi/search"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Sessionapi/search",url)
    return url
}
func sessionallCategoryUrl()-> String {
    var  url = "\(testingServer)Sessionapi/all_category"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Sessionapi/all_category",url)
    return url
}
func sessionBookingUrl()-> String {
    var  url = "\(testingServer)Sessionapi/session_booking"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Sessionapi/session_booking",url)
    return url
}

func selectInterestUrl()-> String{
    var  url = "\(testingServer)Userapi/user_interest_category"
    url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print("Userapi/user_interest_category",url)
    return url
}
