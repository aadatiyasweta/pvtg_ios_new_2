//
//  HomeViewController.swift
//  PVTG
//
//  Created by Test Machine on 22/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import CoreLocation

class HomeViewController: BaseViewController, CLLocationManagerDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var lblNoSession: UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var userimg: UIImageView!
    @IBOutlet weak var lblLocn: UILabel!
    
    @IBOutlet weak var headerTitleLbl: UILabel!
    
    @IBOutlet weak var colectionVw: UICollectionView!{
        didSet{
            colectionVw.dataSource = self
            colectionVw.delegate = self
            self.colectionVw.register(PriceCollCell.nib(), forCellWithReuseIdentifier: PriceCollCell.ident)
            self.colectionVw.register(HomeAllCollectionViewCell.nib(), forCellWithReuseIdentifier: HomeAllCollectionViewCell.ident)
            
            self.colectionVw.register(CategoryCell.nib(), forCellWithReuseIdentifier: CategoryCell.ident)
        }
    }
    
    @IBOutlet weak var tblSession: UITableView!{
        didSet{
            tblSession.dataSource = self
            tblSession.delegate = self
            self.tblSession.register(SessionCell.nib(), forCellReuseIdentifier: SessionCell.ident)
        }
    }
    
    //MARK: - Properties
    var homevm = HomeVM()
    private var locationManager = CLLocationManager()
    var userLocCoordinate = CLLocationCoordinate2D()
    var latitude: Double?
    var lngitude: Double?
    var placesClient: GMSPlacesClient!
    var categoryArr = [Category]()
    var id = "-1"
    var city = ""
    var minimUmPrice = 0
    var maximimPrice = 0
    var origiMinPrice = 0
    var origiMaxPrice = 0
    var selectedCurrency = "COP"
    var isSelectedFromFilter = false
    
    var homeResultData = [All_result]()
    var saveAddressDefault = ""
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNoSession.text = ""
        appDelegate.hitDeviceTokenApi()
        initializeLocation()
        homevm.delegate = self
        DispatchQueue.main.async {
            self.userimg.layer.borderWidth = 0.5
            self.userimg.layer.cornerRadius = 10
            self.userimg.layer.borderColor = UIColor().coloWithHexString(hex: "#05d9bd").cgColor
            self.userimg.image = UIImage(named: "more")
        }
        if SaveToDefaults().getAppLang() ?? "en" == "en"{
            headerTitleLbl.text = "Explore energy healing sessions and balance your soul."
        }else{
            headerTitleLbl.text = "Explora la sesións de sanación energética y equilibra tu alma."
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.id = "-1"
        self.city = SaveToDefaults().getCity() ?? ""
        self.lblLocn.text = self.city
        self.loadApi(categoryid: "\(self.id)", currency: self.selectedCurrency)
        
        if(self.isSelectedFromFilter == false){
            appDelegate.currentVC = self
        }
//        if SaveToDefaults().getAppLang() ?? "en" == "en"{
//            headerTitleLbl.text = "Explore energy healing sessions and balance your soul."
//        }else{
//            headerTitleLbl.text = "Explora la sesións de sanación energética y equilibra tu alma."
//        }
    }
        
//    func initializeLocation() {
//        // Request the appropriate authorization
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.delegate = self // Set the delegate to receive updates
//        getUserCurrentLocation()
//
//        // Check if location services are enabled at the system level
//        DispatchQueue.global(qos: .background).async {
//            if CLLocationManager.locationServicesEnabled() {
//                print("Location services are enabled.")
//            } else {
//                self.showAlertForPermissionDenied()
//            }
//        }
//    }
    
    func initializeLocation() {
        // Request the appropriate authorization
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self // Set the delegate to receive updates
        getUserCurrentLocation()

        // Check if location services are enabled at the system level
        DispatchQueue.global(qos: .background).async {
            if CLLocationManager.locationServicesEnabled() {
                print("Location services are enabled.")
            } else {
                DispatchQueue.main.async {
                    self.showAlertForPermissionDenied()
                }
            }
        }
    }
    func showAlertForPermissionDenied() {
        let alertController = UIAlertController(
            title: R.string.localizable.backGroundLocationdDisabled(),
            message: R.string.localizable.inOrderto(),
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: R.string.localizable.openSettings(), style: .default) { (action) in
            UserDefaults.standard.set(true, forKey: "OpenSettings")
            if let url = NSURL(string:UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        self.present(alertController, animated: true, completion: nil)
        }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            // Authorization not determined yet
            break
        case .restricted, .denied:
            // Location services restricted or denied
            showAlertForPermissionDenied()
        case .authorizedWhenInUse, .authorizedAlways:
            // Start updating location if authorized
            locationManager.startUpdatingLocation()
        @unknown default:
            // Handle unexpected cases
            break
        }
    }
    
    func getUserCurrentLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else {
                return
            }
            self.userLocCoordinate = location.coordinate
            requestToGetAddressFromLatLong(userloc: self.userLocCoordinate)
            locationManager.stopUpdatingLocation()
        }
    
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            self.userLocCoordinate = position.target
            requestToGetAddressFromLatLong(userloc: self.userLocCoordinate)
        }
    
        func requestToGetAddressFromLatLong(userloc:CLLocationCoordinate2D)
        {
            let addressCoordinates = CLLocationCoordinate2DMake(userloc.latitude,userloc.longitude)
            let coder = GMSGeocoder()
            coder.reverseGeocodeCoordinate(addressCoordinates) { response, error in
                if let addrss = response?.firstResult() {
                    let location = CLLocationCoordinate2D(latitude: addressCoordinates.latitude, longitude: addressCoordinates.longitude)
                    self.lblLocn.text = addrss.locality
                    self.city = addrss.locality ?? ""
                    SaveToDefaults().setCity(value: self.city)
                   // UserDefaults.standard.setValue(self.city, forKey: "userAddress")
                    SaveToDefaults().setLatitude(lat: location.latitude)
                    SaveToDefaults().setLongtitude(lon: location.longitude)
                    self.loadApi(categoryid: "\(self.id)", currency: self.selectedCurrency)
                    if let addressLineArray = addrss.lines{
                        if addressLineArray.count>0{
                        }
                    }
                }
            }
        }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setVSViewShadow(radius: 10, color: .black, view: self.btnSearch, opacity: 0.12)
    }
    
    //MARK: - METHOD TO SET DATA
    func loadApi(categoryid: String , minPrice : Int? = 0 , maxPrice : Int? = 0,currency : String) {
        if let userid = SaveToDefaults().getUserId(), let lat = SaveToDefaults().getLatitude(), let lng = SaveToDefaults().getLongtitude() {
            let value = self.lblLocn.text ?? ""
            if self.city == ""{
                if  self.id == "-1"{
                    homevm.getHomeApi(user_id: userid, category_id: "", latitude: "\(lat)", longitude: "\(lng)", search: "", top_search: "", city: value,minPrice: minimUmPrice , maxprice: maximimPrice, currency: currency)
                    
                }else{
                    if categoryid == "0"{
                        homevm.getHomeApi(user_id: userid, category_id: "", latitude: "\(lat)", longitude: "\(lng)", search: "", top_search: "1", city: value,minPrice: minPrice , maxprice: maxPrice, currency: currency)
                    }else{
                        homevm.getHomeApi(user_id: userid, category_id: categoryid, latitude: "\(lat)", longitude: "\(lng)", search: "", top_search: "", city: value,minPrice: minimUmPrice , maxprice: maximimPrice, currency: currency)
                    }
                }
            }else{
                if self.id == "-1"{
                    homevm.getHomeApi(user_id: userid, category_id: "", latitude: "\(lat)", longitude: "\(lng)", search: "", top_search: "", city: self.city,minPrice: minimUmPrice , maxprice: maximimPrice, currency: currency)
                }else{
                    if categoryid == "0"{
                        homevm.getHomeApi(user_id: userid, category_id: "", latitude: "\(lat)", longitude: "\(lng)", search: "", top_search: "1", city: self.city,minPrice: minimUmPrice , maxprice: maximimPrice, currency: currency)
                    }
                    else{
                        homevm.getHomeApi(user_id: userid, category_id: categoryid, latitude: "\(lat)", longitude: "\(lng)", search: "", top_search: "", city: self.city,minPrice: minimUmPrice , maxprice: maximimPrice, currency: currency)
                    }
                }
            }
        }
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func tapSearchLocation(_ sender: UIButton) {
        let vc = SearchLocationVC.instance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnTapToEditProfile(_ sender: UIButton) {
        let vc = ProfileVC.instance()
        self.navigationController?.pushViewController(vc, animated: true)
       
    }
}

//MARK: - TABLE VIEW DELEGATES AND DATASOURCE
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeResultData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SessionCell.ident, for: indexPath) as? SessionCell else { return UITableViewCell()}
        cell.setHomeData(data: self.homeResultData[indexPath.row])
        if(self.homevm.model?.followUp?.follow_up_id != "0" && self.homevm.model?.followUp?.follow_up_id != "" && self.homevm.model?.followUp?.follow_up_id != nil){
            if(indexPath.row == self.homeResultData.count-1){
                cell.followUpView.isHidden = false
            }else{
                cell.followUpView.isHidden = true
            }
        }else{
            cell.followUpView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 418
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SessionDetailVC.instance()
        vc.sessionId = self.homeResultData[indexPath.row].session_id ?? ""
        vc.controllerId = 0
        if(indexPath.row == self.homeResultData.count-1){
            vc.getFollowUpId = self.homevm.model?.followUp?.follow_up_id ?? ""
        }else{
            vc.getFollowUpId = ""
        }
        
        SaveToDefaults().setSessionTimeId(name: self.homeResultData[indexPath.row].session_image)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - COLLECTION VIEW DELEGATE AND DATASOURCE
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            if self.categoryArr.count == 0{
                return 0
            }
            return 1
        }
        if section == 1{
            if self.categoryArr.count == 0{
                return 0
            }
            return 1
        }
        return categoryArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PriceCollCell.ident, for: indexPath) as! PriceCollCell
            if self.isSelectedFromFilter{
                cell.priceLbl.text = "\(self.selectedCurrency)\(self.minimUmPrice)-\(self.selectedCurrency)\(self.maximimPrice)"
            }else{
                cell.priceLbl.text = R.string.localizable.priceFilter()
            }
            return cell
        }
        else if indexPath.section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeAllCollectionViewCell.ident, for: indexPath) as! HomeAllCollectionViewCell
            if(id == "-1" ){
                cell.cellBgVw.backgroundColor = UIColor().coloWithHexString(hex: "#05d9bd")
                cell.cellBgVw.border(width: 1, color: UIColor().coloWithHexString(hex: "#06d9bd"))
                cell.allLbl.textColor = .white
            }else{
                cell.cellBgVw.backgroundColor = UIColor().coloWithHexString(hex: "#ffffff")
                cell.cellBgVw.border(width: 1, color: UIColor().coloWithHexString(hex: "#E2E2E2"))
                cell.allLbl.textColor = .black
            }
            cell.cellBgVw.layer.borderWidth = 1
            cell.cellBgVw.layer.cornerRadius = 5
                //cell.priceLbl.text = "All"
            return cell
        }
        else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.ident, for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
            cell.lblCategory.numberOfLines = 3
            cell.leadingConstrain.constant = 5
            cell.trailingConstrainOuterview.constant = 0
 
            if self.categoryArr.count == 2{
                if self.categoryArr[1].image == ""{
                    if indexPath.row == 0{
                        cell.vwcategory.backgroundColor = UIColor().coloWithHexString(hex: "#05d9bd")
                        cell.vwcategory.border(width: 1, color: UIColor().coloWithHexString(hex: "#06d9bd"))
                        cell.lblCategory.textColor = .white
                        cell.setdata(data:categoryArr[indexPath.row])
                    }else{
                        cell.imgcategory.image = #imageLiteral(resourceName: "star-grey")
                        cell.lblCategory.textColor = .black
                        cell.vwcategory.backgroundColor = UIColor().coloWithHexString(hex: "#ffffff")
                        cell.vwcategory.border(width: 1, color: UIColor().coloWithHexString(hex: "#E2E2E2"))
                        cell.lblCategory.text = categoryArr[indexPath.row].name
                    }
                }else{
                    if id == categoryArr[indexPath.row].id{
                        cell.vwcategory.backgroundColor = UIColor().coloWithHexString(hex: "#05d9bd")
                        cell.vwcategory.border(width: 1, color: UIColor().coloWithHexString(hex: "#06d9bd"))
                        cell.lblCategory.textColor = .white
                    } else {
                        cell.vwcategory.backgroundColor = .white
                        cell.vwcategory.border(width: 1, color: UIColor().coloWithHexString(hex: "#E2E2E2"))
                        cell.lblCategory.textColor = .black
                    }
                    cell.setdata(data:categoryArr[indexPath.row])
                }
            }else{
                if id == categoryArr[indexPath.row].id {
                    cell.vwcategory.backgroundColor = UIColor().coloWithHexString(hex: "#05d9bd")
                    cell.vwcategory.border(width: 1, color: UIColor().coloWithHexString(hex: "#06d9bd"))
                    cell.lblCategory.textColor = .white
                } else {
                    cell.vwcategory.backgroundColor = .white
                    cell.vwcategory.border(width: 1, color: UIColor().coloWithHexString(hex: "#E2E2E2"))
                    cell.lblCategory.textColor = .black
                }
                cell.setdata(data:categoryArr[indexPath.row])
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            let label = UILabel(frame: CGRect.zero)
            if self.isSelectedFromFilter{
                label.text = "\(self.selectedCurrency)\(self.minimUmPrice)-\(self.selectedCurrency)\(self.maximimPrice)"
            }else{
                label.text = R.string.localizable.priceFilter()
            }
            label.sizeToFit()
            return CGSize(width: label.frame.size.width + 30, height: 65)
        }
        if indexPath.section == 1{
            return CGSize(width: 80, height: 65)
        }
        let text = categoryArr[indexPath.row].name
        let label = UILabel(frame: CGRect.zero)
        label.text = text
        label.sizeToFit()
        return CGSize(width: label.frame.size.width + 74, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let priceView = PriceView.initWith(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
            priceView?.delegate = self
            priceView?.seekView.minValue = CGFloat(self.origiMinPrice)
            if(self.selectedCurrency == "USD"){
                priceView?.seekView.maxValue = CGFloat(300)
            }else {
                priceView?.seekView.maxValue = CGFloat(1000000)
            }
            priceView?.selectCurrencyFiled.text = self.selectedCurrency
            priceView?.seekView.selectedMaxValue = CGFloat(self.maximimPrice)
            priceView?.seekView.selectedMinValue = CGFloat(self.minimUmPrice)
            priceView?.selectedCurrency = self.selectedCurrency
            priceView?.maxValue = self.maximimPrice
            priceView?.minimumValue = self.minimUmPrice
            priceView?.currencyArr = self.homevm.model?.currency_data ?? []
            
            appDelegate.window?.addSubview(priceView!)
            for val in 0..<(self.homevm.model?.currency_data!.count)!{
                if self.homevm.model?.currency_data?[val] == self.selectedCurrency{
                    priceView?.currentIndex = val
                    priceView?.pickerView.selectRow(priceView!.currentIndex, inComponent: 0, animated: true)
                    priceView?.pickerView.reloadAllComponents()
                    break
                }
            }
        }else if(indexPath.section == 1){
            self.id = "-1"
            self.loadApi(categoryid: "\(self.id)", currency: self.selectedCurrency)
        }
        else{
            if self.categoryArr.count == 2{
                if self.categoryArr[1].image == ""{
                    if indexPath.row == 0{
                        id = "0"
                        loadApi(categoryid: "0", currency: self.selectedCurrency)
                    }else{
                        let vc = TransformerExampleViewController.instance()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else{
                    if id == categoryArr[indexPath.row].id ?? "" {
                    } else {
                        id = categoryArr[indexPath.row].id ?? ""
                        if id == "0" {
                            loadApi(categoryid: "0", currency: self.selectedCurrency)
                        }else {
                            loadApi(categoryid: categoryArr[indexPath.row].id ?? "", currency: self.selectedCurrency)
                        }
                    }
                }
            }else{
                if id == categoryArr[indexPath.row].id ?? "" {
                } else {
                    id = categoryArr[indexPath.row].id ?? ""
                    if id == "0" {
                        loadApi(categoryid: "0", currency: self.selectedCurrency)
                    }else {
                        loadApi(categoryid: categoryArr[indexPath.row].id ?? "", currency: self.selectedCurrency)
                    }
                }
            }
        }
    }
}

//MARK: - CUSTOM DELEGATE
extension HomeViewController: GetHomeData {
    func reloadData(unreadNotificationCount : Int) {
        homeResultData.removeAll()
        if self.maximimPrice == 0{
            self.minimUmPrice = self.homevm.model?.min_val ?? 0
            self.maximimPrice = self.homevm.model?.max_val ?? 0
        }
        if(unreadNotificationCount != 0){
            self.tabBarController?.addBadge(index: 3, value: unreadNotificationCount, color: .red, font:UIFont.systemFont(ofSize: 14.0, weight: .regular))
        }else {
            self.tabBarController?.tabBar.removeBadge(index: 3)
        }
        self.origiMinPrice = self.homevm.model?.min_price ?? 0
        self.origiMaxPrice = self.homevm.model?.max_price ?? 0
        loadImage(self.homevm.model?.user_image ?? "", self.userimg , activity: nil, defaultImage: #imageLiteral(resourceName: "more"))
        self.categoryArr.removeAll()
        //self.categoryArr.append(Category(name: "All", image: allHomeData, id: "0"))
        self.categoryArr.append(Category(name: R.string.localizable.topSearch(), image: topSearch, id: "0"))
        guard let data = self.homevm.model?.all_category else { return }
        if data.count == 0{
            self.categoryArr.append(Category(name: R.string.localizable.addIntersetMoreRecommen(), image: "", id: ""))
        }else{
            for i in data{
                self.categoryArr.append(Category(name: i.category_name ?? "", image: i.category_image ?? "", id: i.category_id ?? ""))
            }
        }
        self.selectedCurrency = self.homevm.model?.selected_currency ?? "COP"
        
        for i in 0..<(self.homevm.model?.all_result?.count ?? 0){
            homeResultData.append((self.homevm.model?.all_result?[i])!)
        }
        
        if(self.homevm.model?.followUp?.follow_up_id != "0" && self.homevm.model?.followUp?.follow_up_id != "" && self.homevm.model?.followUp?.follow_up_id != nil){
            homeResultData.append((self.homevm.model?.followUp)!)
        }
        if  self.homeResultData.count == 0 {
            self.lblNoSession.text = R.string.localizable.noSession()
        } else {
            self.lblNoSession.text = ""
        }

        
        self.colectionVw.reloadData()
        self.tblSession.reloadData()
        if self.homeResultData.count != 0{
            self.tblSession.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
        }
    }
}

//MARK: - GET SLIDER VALUE EXTENSION
extension HomeViewController : getPriceSliderValues{
    func slidermaxMinValue(min: Int, max: Int, currency: String,isSelectedFromFilter : Bool) {
        self.isSelectedFromFilter = isSelectedFromFilter
        self.selectedCurrency = currency
        self.maximimPrice = max
        self.minimUmPrice = min
        self.loadApi(categoryid: id,minPrice: min , maxPrice: max, currency: currency)
    }
    
    func resetFilter() {
        self.isSelectedFromFilter = false
        self.maximimPrice = 1000000
        self.minimUmPrice = 0
        loadApi(categoryid: "\(id)", currency: self.selectedCurrency)
    }
    
    func setProfilePic() {
    }
    
//    func onDeniedLocatin(){
//        switch CLLocationManager.authorizationStatus() {
//        case .notDetermined, .restricted, .denied:
//            let alertController = UIAlertController(
//                title: R.string.localizable.backGroundLocationdDisabled(),
//                message: R.string.localizable.inOrderto(),
//                preferredStyle: .alert)
//            UserDefaults.standard.removeObject(forKey: "userAddress")
//            let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: nil)
//            alertController.addAction(cancelAction)
//            
//            let openAction = UIAlertAction(title: R.string.localizable.openSettings(), style: .default) { (action) in
//                UserDefaults.standard.set(true, forKey: "OpenSettings")
//                if let url = NSURL(string:UIApplication.openSettingsURLString) {
//                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
//                }
//            }
//            alertController.addAction(openAction)
//            self.present(alertController, animated: true, completion: nil)
//        case .authorizedAlways:
//            print("notDet6ermined")
//        case .authorizedWhenInUse:
//            print("AuthorizationWhenInUse")
//        @unknown default:
//            print("notDet6ermined")
//        }
    }
    
    //MARK: - Re-enabel location permission
//    internal func checkAndEnabelLocationPermission() {
//        if CLLocationManager.locationServicesEnabled() {
//            return
//        }
//        
//        let allow = UIAlertAction(title: R.string.localizable.allow(), style: UIAlertAction.Style.default) { ( action) in
//            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
//                return
//            }
//            if UIApplication.shared.canOpenURL(settingsUrl) {
//                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
//            }
//        }
//        
//        let dontAllow = UIAlertAction(title: R.string.localizable.donotAllow(), style: UIAlertAction.Style.default) { ( action) in
//            self.locationManager.startUpdatingLocation()
//        }
//    }
//}

extension Bundle {
    var version: String {
        return getVersion()
    }
    private func getVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    var appName: String {
        return Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
    var locationPermissionMessage: String {
        return Bundle.main.infoDictionary?["NSLocationAlwaysAndWhenInUseUsageDescription"] as? String ?? ""
    }
    
}
