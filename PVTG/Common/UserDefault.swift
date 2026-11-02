
import Foundation
import KeychainSwift

enum ProfileInfoKeys : String {
    case unreadCount
    case isPush
    case gender
    case dob
    case weight
    case heightUnit
    case heightValue
    case bloodGroup
    case profilePic
    case email
    case name
    case player_id
    case expiresIn
    case refreshToken
    case clientSecret
    case clientId
    case accessToken
    case mobile
    case freshUser
    case encodedPassword
    case country
    case city
    case locality
    case address
    case startTimeStamp
    case smoke
    case exercise
    case alcohol
    case meat
    case profilePercent
    case isnew
    case otpVerified
    case lockerPin
    case authverification
    case lat
    case lon
    case patientId
    case snoozeDuration
    case reminderVibrate
    case reminderVolume
    case openPopUp
    case is_sport_selected
    case onboarding
    case notification_status
    case interset
    case time
    case lang
    case firstName
    case lastName
    case homeData
    case homeData1
    case userName
    case currentId
}

enum UserLocation :String{
    case lat = "latitude"
    case long = "longtitude"
    case location = "location"
}

//MARK: - SECURE STORE
/// Keeps login credentials in the Keychain (encrypted, not included in backups) instead of UserDefaults.
final class SecureStore {
    static let shared = SecureStore()

    /// Keys that hold login credentials; they use the same names as the old UserDefaults keys.
    static let secureKeys: [ProfileInfoKeys] = [.accessToken, .refreshToken, .clientSecret, .clientId, .encodedPassword, .homeData1, .authverification]

    private let keychain = KeychainSwift(keyPrefix: "dharma_secure_")
    private let access: KeychainSwiftAccessOptions = .accessibleAfterFirstUnlockThisDeviceOnly
    private let migratedKey = "secureStoreMigrated"

    private init() {
        guard !defaults.bool(forKey: migratedKey) else { return }
        // Keychain items survive deleting the app, so remove anything left from a previous install
        SecureStore.secureKeys.forEach { keychain.delete($0.rawValue) }
        // Move credentials saved by older app versions out of UserDefaults
        for key in SecureStore.secureKeys {
            if let value = defaults.string(forKey: key.rawValue) {
                keychain.set(value, forKey: key.rawValue, withAccess: access)
            } else if let data = defaults.data(forKey: key.rawValue) {
                keychain.set(data, forKey: key.rawValue, withAccess: access)
            }
            defaults.removeObject(forKey: key.rawValue)
        }
        defaults.set(true, forKey: migratedKey)
    }

    func set(_ value: String?, for key: ProfileInfoKeys) {
        if let value = value, !value.isEmpty {
            keychain.set(value, forKey: key.rawValue, withAccess: access)
        } else {
            keychain.delete(key.rawValue)
        }
    }

    func string(for key: ProfileInfoKeys) -> String? {
        return keychain.get(key.rawValue)
    }

    func set(_ data: Data?, for key: ProfileInfoKeys) {
        if let data = data, !data.isEmpty {
            keychain.set(data, forKey: key.rawValue, withAccess: access)
        } else {
            keychain.delete(key.rawValue)
        }
    }

    func data(for key: ProfileInfoKeys) -> Data? {
        return keychain.getData(key.rawValue)
    }

    func removeAll() {
        SecureStore.secureKeys.forEach { keychain.delete($0.rawValue) }
    }
}

struct SaveToDefaults {
    func getSessionLatitude() -> Double? {
        let lat = defaults.double(forKey: "sessionLat")
        return lat
    }
    
    func seSessiontLatitude(lat:Double?){
        defaults.set(lat, forKey: "sessionLat")
    }
    
    func getSessionLongitude() -> Double? {
        let lat = defaults.double(forKey: "sessionLng")
        return lat
    }
    
    func seSessiontLongitude(lat:Double?){
        defaults.set(lat, forKey: "sessionLng")
    }
    
    func setLocationArr(loc: [String]?) {
        defaults.set(loc, forKey: "loc")
    }
    
    func getLocationArr()-> [String]? {
        return defaults.array(forKey: "loc") as? [String]? ?? []
    }
    
    func setPhoneNumber(phone: String) {
        defaults.set(phone, forKey: "phone")
    }
    
    func GetCurrentID() -> String? {
        return defaults.value(forKey: "phone") as? String
    }
    
    func setLocationLateArr(loc: [[String:String]]) {
        defaults.set(loc, forKey: "setLocationLateArr")
    }
    
    func getLocationLateArr()-> [[String:String]]? {
        return defaults.array(forKey: "setLocationLateArr") as? [[String : String]]
    }
    
    func setLogindata(data: Data) {
        SecureStore.shared.set(data, for: .homeData1)
    }
    func getLoginData()->Data?{
        return SecureStore.shared.data(for: .homeData1)
    }
    
    func setCurrentID(ID :  Int?) {
        defaults.set(ID, forKey: ProfileInfoKeys.currentId.rawValue)
    }
    
    func GetCurrentID() -> Int? {
        return defaults.value(forKey: ProfileInfoKeys.currentId.rawValue) as? Int
    }
    
    func setProfilePercent(percent : Int?) {
        defaults.set(percent, forKey: ProfileInfoKeys.profilePercent.rawValue)
    }
    
    func setAccessToken(value : String?) {
        SecureStore.shared.set(value, for: .accessToken)
    }

    func getAccessToken()->String?{
        return SecureStore.shared.string(for: .accessToken)
    }
    
    func getProfilePercent() -> Int? {
        return defaults.value(forKey: ProfileInfoKeys.profilePercent.rawValue) as? Int
    }
    
    func setPin(pin : Bool?) {
        defaults.set(pin, forKey: ProfileInfoKeys.lockerPin.rawValue)
    }
    
    func setSID(sid : Int?) {
        defaults.set(sid, forKey: "sid")
    }
    
    func getSID()->Int?{
        return defaults.value(forKey: "sid") as? Int
    }
    
    func setFcmToken(token : String?) {
        defaults.set(token, forKey: "fcm")
    }
    
    func getFcmToken()->String?{
        return defaults.value(forKey: "fcm") as? String
    }
    
    func getPin() -> Bool? {
        return defaults.value(forKey: ProfileInfoKeys.lockerPin.rawValue) as? Bool
    }
    
    func setHomeData(data : Data){
        defaults.set(data, forKey: ProfileInfoKeys.homeData.rawValue)
    }
    
    func getHomeData()->Data?{
        return defaults.value(forKey: ProfileInfoKeys.homeData.rawValue) as? Data
    }
    
    func setWeight(weight :  Int?) {
        print("set weight : " , weight ?? "")
        defaults.set(weight, forKey: ProfileInfoKeys.weight.rawValue)
    }
    
    func getWeight() -> Int? {
        return defaults.value(forKey: ProfileInfoKeys.weight.rawValue) as? Int
    }
    
    func setProfilePic(value : String?) {
        if let value = value , !value.isEmpty{
            defaults.set(value, forKey: ProfileInfoKeys.profilePic.rawValue)
        } else {
            defaults.set(nil, forKey: ProfileInfoKeys.profilePic.rawValue)
        }
    }
    
    func getProfilePic()->String?{
        let value = defaults.value(forKey: ProfileInfoKeys.profilePic.rawValue) as? String
        return value
    }
    
    func setSessionImage(value : String?) {
        if let value = value , !value.isEmpty{
            defaults.set(value, forKey: "sessionimage")
        } else {
            defaults.set(nil, forKey: "sessionimage")
        }
    }
    
    func getSessionImage()->String?{
        let value = defaults.value(forKey: "sessionimage") as? String
        return value
    }
    
    func setEmail(value : String?) {
        defaults.set(value, forKey: ProfileInfoKeys.email.rawValue)
    }
    
    func getEmail()->String?{
        let value = defaults.value(forKey: ProfileInfoKeys.email.rawValue) as? String
        return value
    }
    
    func setIsPush(value : Bool?) {
        defaults.set(value, forKey: ProfileInfoKeys.isPush.rawValue)
    }
    
    func getIsPush()->Bool?{
        let value = defaults.value(forKey: ProfileInfoKeys.isPush.rawValue) as? Bool
        return value
    }
    
    func setName(value : String?) {
        defaults.set(value, forKey: ProfileInfoKeys.name.rawValue)
    }
    
    func getName()->String?{
        let value = defaults.value(forKey: ProfileInfoKeys.name.rawValue) as? String
        return value
    }
    
    func setunreadCount(value : Int?) {
        defaults.set(value, forKey: ProfileInfoKeys.unreadCount.rawValue)
    }
    
    func getunreadCount()->Int?{
        let value = defaults.value(forKey: ProfileInfoKeys.unreadCount.rawValue) as? Int
        return value
    }
    
    func setFirstName(value : String?) {
        defaults.set(value, forKey: ProfileInfoKeys.firstName.rawValue)
    }
    
    func setUserName(value: String) {
        defaults.set(value, forKey: ProfileInfoKeys.userName.rawValue)
    }
    
    func getUserName()->String?{
        let value = defaults.value(forKey: ProfileInfoKeys.userName.rawValue) as? String
        return value
    }
    
    func getFirstName()->String?{
        let value = defaults.value(forKey: ProfileInfoKeys.firstName.rawValue) as? String
        return value
    }
    
    func setLastName(value : String?) {
        defaults.set(value, forKey: ProfileInfoKeys.lastName.rawValue)
        
    }
    
    func getLastName()->String?{
        let value = defaults.value(forKey: ProfileInfoKeys.lastName.rawValue) as? String
        return value
    }
    
    func setExpiresIn(value : Int?) {
        defaults.set(value, forKey: ProfileInfoKeys.expiresIn.rawValue)
    }
    
    func getExpiresIn()->Int?{
        let value = defaults.value(forKey: ProfileInfoKeys.expiresIn.rawValue) as? Int
        return value
    }
    
    func setRefreshToken(value : String?) {
        SecureStore.shared.set(value, for: .refreshToken)
    }

    func getRefreshToken()->String?{
        return SecureStore.shared.string(for: .refreshToken)
    }

    func setClientSecret(value : String?) {
        SecureStore.shared.set(value, for: .clientSecret)
    }

    func getClientSecret()->String?{
        return SecureStore.shared.string(for: .clientSecret)
    }

    func setClientId(value : String?) {
        SecureStore.shared.set(value, for: .clientId)
    }

    func getClientId()->String?{
        return SecureStore.shared.string(for: .clientId)
    }
    
    func setMobile(value : String?) {
        defaults.set(value, forKey: ProfileInfoKeys.mobile.rawValue)
    }
    
    func getMobile()->String?{
        let value = defaults.value(forKey: ProfileInfoKeys.mobile.rawValue) as? String
        return value
    }
    
    func setIsFreshUser(value : Bool?) {
        defaults.set(value, forKey: ProfileInfoKeys.freshUser.rawValue)
    }
    
    func getIsFreshUser()->Bool?{
        let value = defaults.value(forKey: ProfileInfoKeys.freshUser.rawValue) as? Bool
        return value
    }
    
    func setEncodedPassword(value : String?) {
        SecureStore.shared.set(value, for: .encodedPassword)
    }

    func getEncodedPassword()->String?{
        return SecureStore.shared.string(for: .encodedPassword)
    }
    
    func setAppLang(value : String?) {
        defaults.set(value, forKey: ProfileInfoKeys.lang.rawValue)
    }
    
    func getAppLang()->String?{
        let value = defaults.value(forKey: ProfileInfoKeys.lang.rawValue) as? String
        return value
    }
    
    func setCountry(value : String?) {
        defaults.set(value, forKey: ProfileInfoKeys.country.rawValue)
    }
    
    func getCountry()->String?{
        let value = defaults.value(forKey: ProfileInfoKeys.country.rawValue) as? String
        return value
    }
    
    func setCity(value : String?) {
        defaults.set(value, forKey: ProfileInfoKeys.city.rawValue)
    }
    
    func getCity()->String?{
        let value = defaults.value(forKey: ProfileInfoKeys.city.rawValue) as? String
        return value
    }
    
    func setLocality(value : String?) {
        defaults.set(value, forKey: ProfileInfoKeys.locality.rawValue)
    }
    
    func getLocality()->String?{
        let value = defaults.value(forKey: ProfileInfoKeys.locality.rawValue) as? String
        return value
    }
    
    func setAddress(value : String?) {
        defaults.set(value, forKey: ProfileInfoKeys.address.rawValue)
    }
    
    func getAddress()->String?{
        let value = defaults.value(forKey: ProfileInfoKeys.address.rawValue) as? String
        return value
    }
    
    func setTokenTimeStamp(_ timestamp : Double?) {
        defaults.set(timestamp, forKey: ProfileInfoKeys.startTimeStamp.rawValue)
    }
    
    func getTokenTimeStamp() -> Double? {
        let timestamp = defaults.double(forKey: ProfileInfoKeys.startTimeStamp.rawValue)
        return timestamp
    }
    
    func setIsNew(isNew : Bool?) {
        defaults.set(isNew, forKey: ProfileInfoKeys.isnew.rawValue)
    }
    
    func getIsNew() -> Bool? {
        let IsNew = defaults.bool(forKey: ProfileInfoKeys.isnew.rawValue)
        return IsNew
    }
    
    func setOtpVerified(verified : Bool?) {
        defaults.set(verified, forKey: ProfileInfoKeys.otpVerified.rawValue)
    }
    
    func getOtpVerfied() -> Bool? {
        let IsNew = defaults.bool(forKey: ProfileInfoKeys.otpVerified.rawValue)
        return IsNew
    }
    
    func getLatitude() -> Double? {
        let lat = defaults.double(forKey: ProfileInfoKeys.lat.rawValue)
        return lat
    }
    
    func setLatitude(lat:Double?){
        defaults.set(lat, forKey: ProfileInfoKeys.lat.rawValue)
    }
    
    func setformattedAddress(lat:String?){
        defaults.set(lat, forKey: "address")
    }
    
    func getformattedAddress() -> String? {
        let lat = defaults.string(forKey: "address")
        return lat
    }
    
    func getLongtitude() -> Double? {
        let lat = defaults.double(forKey: ProfileInfoKeys.lon.rawValue)
        return lat
    }
    
    func setLongtitude(lon:Double?){
        defaults.set(lon, forKey: ProfileInfoKeys.lon.rawValue)
    }
    
    func getUserId() -> String? {
        if let id = defaults.value(forKey: ProfileInfoKeys.patientId.rawValue) as? String {
            return id
        }
        return nil
    }
    
    func setUserId(id:String?){
        defaults.set(id, forKey: ProfileInfoKeys.patientId.rawValue)
    }
    
    func setDOB(dob : String?) {
        defaults.set(dob, forKey: ProfileInfoKeys.dob.rawValue)
    }
    
    func getDOB() -> String? {
        return defaults.value(forKey: ProfileInfoKeys.dob.rawValue) as? String
    }
    
    func getTime() -> String? {
        if let time = defaults.value(forKey: ProfileInfoKeys.time.rawValue) as? String {
            return time
        }
        return nil
    }
    
    func setTime(time:String?){
        defaults.set(time, forKey: ProfileInfoKeys.time.rawValue)
    }
    
    func getIsSportSelected() -> Bool? {
        if let id = defaults.value(forKey: ProfileInfoKeys.is_sport_selected.rawValue) as? Bool {
            return id
        }
        return nil
    }
    
    func setIsSportSelected(id:Bool?){
        defaults.set(id, forKey: ProfileInfoKeys.is_sport_selected.rawValue)
    }
    
    func getIsOnboardingCompleted() -> Bool? {
        if let id = defaults.value(forKey: ProfileInfoKeys.onboarding.rawValue) as? Bool {
            return id
        }
        return nil
    }
    
    func setNotificationStatus(id:Bool?){
        defaults.set(id, forKey: ProfileInfoKeys.notification_status.rawValue)
    }
    
    func setremainingTkt(tkt : String){
        defaults.set(tkt, forKey: ProfileInfoKeys.interset.rawValue)
    }
    
    func getremainingTkt()->String{
        if let interst = defaults.value(forKey: ProfileInfoKeys.interset.rawValue) as? String{
            return interst
        }
        return ""
    }
    
    func getNotificationStatus() -> Bool? {
        if let id = defaults.value(forKey: ProfileInfoKeys.notification_status.rawValue) as? Bool {
            return id
        }
        return nil
    }
    
    func setIsOnboardingCompleted(id:Bool?){
        defaults.set(id, forKey: ProfileInfoKeys.onboarding.rawValue)
    }
    
    func SetDictBirthArry(birth : [[String : Any]]){
        defaults.set(birth, forKey: "birth")
    }
    
    func getDictBirthArry()-> [[String: Any]]{
        if let birth = defaults.array(forKey: "birth") as? [[String: Any]]{
            return birth
        }
        return [[:]]
    }
    
    func setSessionTimeId(name: String?) {
        defaults.set(name, forKey: "name")
    }
    
    func getSessionTimeId()-> String {
        return defaults.value(forKey: "name") as? String ?? ""
    }
    
    func setDob(dob: String?) {
        defaults.set(dob, forKey: "dob")
    }
    
    func getDob()-> String {
        return defaults.value(forKey: "dob") as? String ?? ""
    }
    
    func setGender(name: String?) {
    }
    
    func getGender()-> String {
        return defaults.value(forKey: "gender") as? String ?? ""
    }
    
    func setSkill(name: Int?) {
    }
    
    func getSkill()-> [Int] {
        return defaults.array(forKey: "skill") as? [Int] ?? []
    }
    
    func setProfilePicture(name: String?) {
    }
    
    func getProfilePicture()-> String {
        return defaults.value(forKey: "profilePicture") as? String ?? ""
    }
    
    func setAboutUs(name: String?) {
        return defaults.set(name, forKey: "aboutus")
    }
    
    func getAboutUs()-> String {
        return defaults.value(forKey: "aboutus") as? String ?? ""
    }
    
    func setFcmAuth(token : String?) {
        SecureStore.shared.set(token, for: .authverification)
    }

    func getFcmAuth()->String?{
        return SecureStore.shared.string(for: .authverification)
    }
}

func removeLoginDetails() {
    SaveToDefaults().setMobile(value: nil)
    SaveToDefaults().setEmail(value: nil)
    SaveToDefaults().setName(value: nil)
    SaveToDefaults().setFirstName(value: nil)
    SaveToDefaults().setLastName(value: nil)
    SaveToDefaults().setUserId(id: nil)
    // Clears the token and all other saved credentials from the Keychain
    SecureStore.shared.removeAll()
}


