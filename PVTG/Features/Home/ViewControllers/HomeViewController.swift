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


class HomeViewController: BaseViewController {
    //MARK:- IBOutlets
    
    @IBOutlet weak var lblNoSession: UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var userimg: UIImageView!
    @IBOutlet weak var lblLocn: UILabel!
    @IBOutlet weak var colectionVw: UICollectionView!{
        didSet{
            colectionVw.dataSource = self
            colectionVw.delegate = self
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
    //MARK:- VAriables
    var homevm = HomeVM()
    private var locationManager = CLLocationManager()
    var userLocCoordinate = CLLocationCoordinate2D()
    var latitude: Double?
    var lngitude: Double?
    var placesClient: GMSPlacesClient!
    var categoryArr = [Category]()
    var id = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.locationManager.startUpdatingLocation()
        lblNoSession.text = ""
        toDelegateSelf()
        placesClient = GMSPlacesClient.shared()
        appDelegate.hitDeviceTokenApi()
        homevm.delegate = self
        DispatchQueue.main.async {
            self.userimg.layer.borderWidth = 0.5
            self.userimg.layer.cornerRadius = 10
            self.userimg.layer.borderColor = UIColor().coloWithHexString(hex: "#05d9bd").cgColor

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadApi(categoryid: "\(id)")
        guard let address = SaveToDefaults().getformattedAddress() else { return}
        if let pic = SaveToDefaults().getProfilePic() {
        loadImage(pic, self.userimg, activity: nil, defaultImage: UIImage(named: "more"))
        }
        self.lblLocn.text = address
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setVSViewShadow(radius: 10, color: .black, view: self.btnSearch, opacity: 0.12)
        
    }

    
    
    func loadApi(categoryid: String) {
        if let userid = SaveToDefaults().getUserId(), let lat = SaveToDefaults().getLatitude(), let lng = SaveToDefaults().getLongtitude() {
            homevm.getHomeApi(user_id: userid, category_id: categoryid, latitude: "\(lat)", longitude: "\(lng)", search: "", top_search: "")
            
        }
    }
    
    //MARK:- IBActions
    @IBAction func tapSearchLocation(_ sender: UIButton) {
        let vc = SearchLocationVC.instance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func btnTapToEditProfile(_ sender: UIButton) {
        let vc = ProfileVC.instance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.homevm.model?.all_result?.count ?? 0)
        return self.homevm.model?.all_result?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SessionCell.ident, for: indexPath) as? SessionCell else { return UITableViewCell()}
        cell.setHomeData(data: self.homevm.model?.all_result?[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 418
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SessionDetailVC.instance()
        vc.sessionId = self.homevm.model?.all_result?[indexPath.row].session_id ?? ""
        vc.controllerId = 0
        SaveToDefaults().setSessionTimeId(name: self.homevm.model?.all_result?[indexPath.row].session_image)
        //vc.lat = self.homevm.model?.all_result?[indexPath.row].
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.ident, for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
        if indexPath.row == 0 {
            cell.leadingConstrain.constant = 22
            cell.trailingConstrainOuterview.constant = 0
        } else {
            cell.leadingConstrain.constant = 5
            if indexPath.row == categoryArr.count-1 {
                cell.trailingConstrainOuterview.constant = 20
            } else {
                cell.trailingConstrainOuterview.constant = 0
            }
        }
        if self.categoryArr.count == 2{
            if self.categoryArr[1].image == ""{
                if indexPath.row == 0{
                    cell.vwcategory.backgroundColor = .white
                    cell.vwcategory.border(width: 1, color: UIColor().coloWithHexString(hex: "#E2E2E2"))
                    cell.lblCategory.textColor = .black
                    cell.setdata(data:categoryArr[indexPath.row])
                }else{
                    cell.imgcategory.image = #imageLiteral(resourceName: "star")
                    cell.lblCategory.textColor = .white
                    cell.vwcategory.backgroundColor = UIColor().coloWithHexString(hex: "#05d9bd")
                    cell.vwcategory.border(width: 1, color: UIColor().coloWithHexString(hex: "#06d9bd"))
                    cell.lblCategory.text = categoryArr[indexPath.row].name
                }
                
            }else{
                if id == indexPath.row {
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
            if id == indexPath.row {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                let text = categoryArr[indexPath.row].name
        
      //  let fontAttributes = [NSAttributedString.Key.font: UIFont.init(name: Fonts.regular.rawValue, size: 12)]
      //  let new = (text as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
    
             let label = UILabel(frame: CGRect.zero)
                label.text = text
                label.sizeToFit()
        return CGSize(width: label.frame.size.width + 71, height: 65)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.categoryArr.count == 2{
            if self.categoryArr[1].image == ""{
                if indexPath.row == 0{
                      loadApi(categoryid: categoryArr[indexPath.row].id ?? "")
                }else{
                    let vc = TransformerExampleViewController.instance()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                if id == indexPath.row {
                    id = -1
                } else {
                    id = indexPath.row
                }
                loadApi(categoryid: categoryArr[indexPath.row].id ?? "")
            }
            
        }else{
            if id == indexPath.row {
                id = -1
            } else {
                id = indexPath.row
            }
            loadApi(categoryid: categoryArr[indexPath.row].id ?? "")
        }
        
       
    }
}

extension HomeViewController: CLLocationManagerDelegate{
    func toDelegateSelf(){
         locationManager.requestWhenInUseAuthorization()
              if CLLocationManager.locationServicesEnabled()
              {
                  locationManager.delegate = self
                  locationManager.desiredAccuracy = kCLLocationAccuracyBest
                  locationManager.startUpdatingLocation()
              }
    }
        //MARK: - CLLocation Delegate
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .authorizedWhenInUse :
                break
            case .restricted :
                self.onDeniedLocatin()
            case .denied :
                self.onDeniedLocatin()
            default :
                break
            }
            
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
//        func addCurrentLocationMarker() {
//            currentLocationMarker?.map = nil
//            currentLocationMarker = nil
//            if let location = locationManager.location {
//                currentLocationMarker = GMSMarker(position:userLocCoordinate)
//                currentLocationMarker?.icon = UIImage(named:"pin")
//                currentLocationMarker?.map = mapV
//                self.mapV.settings.rotateGestures = false
//                self.mapV.settings.tiltGestures = false
//            }
//        }
        func requestToGetAddressFromLatLong(userloc:CLLocationCoordinate2D)
        {
            let addressCoordinates = CLLocationCoordinate2DMake(userloc.latitude,userloc.longitude)
            let coder = GMSGeocoder()
            
            coder.reverseGeocodeCoordinate(addressCoordinates) { response, error in
                if let addrss = response?.firstResult() {
                    var arrLoc = [String]()
                    self.lblLocn.text = addrss.locality
                    arrLoc.append(self.lblLocn.text ?? "")
                    SaveToDefaults().setformattedAddress(lat: self.lblLocn.text)
                    if let addressLineArray = addrss.lines{
                        if addressLineArray.count>0{
                           // self.txtAddress.text = getAddress
                            
                        }
                    }
                }
            }
        }
    }

extension HomeViewController: GetHomeData {
    func reloadData() {
        self.categoryArr.removeAll()
        self.categoryArr.append(Category(name: "Top Search", image: topSearch, id: ""))
        guard let data = self.homevm.model?.all_category else { return }
        if data.count == 0{
             self.categoryArr.append(Category(name: "Add Interests for more recommendations", image: "", id: ""))
        }else{
            for i in data{
                self.categoryArr.append(Category(name: i.category_name ?? "", image: i.category_image ?? "", id: i.category_id ?? ""))
            }
        }
       
        if self.homevm.model?.all_result?.count == 0 {
            self.lblNoSession.text = "No sessions"
        } else {
            self.lblNoSession.text = ""
        }
        self.colectionVw.reloadData()
        self.tblSession.reloadData()
    }
    
    
    
}

extension HomeViewController {
    func setProfilePic() {
        if let pic = SaveToDefaults().getProfilePic() {
            loadImage(pic, self.userimg, activity: nil, defaultImage: nil)
        }
    }
    func onDeniedLocatin(){
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined, .restricted, .denied:
            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "In order to be notified, please open this app's settings and set location access to 'Always'.",
                preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                UserDefaults.standard.set(true, forKey: "OpenSettings")
                if let url = NSURL(string:UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                }
            }
            alertController.addAction(openAction)
            self.present(alertController, animated: true, completion: nil)
        case .authorizedAlways:
            print("notDet6ermined")
        case .authorizedWhenInUse:
            print("AuthorizationWhenInUse")
        @unknown default:
            print("notDet6ermined")
        }
    }
    
    
    //MARK:- Re-enabel location permission
      internal func checkAndEnabelLocationPermission() {
          
          if CLLocationManager.locationServicesEnabled() {
              return
          }
          
          let allow = UIAlertAction(title: "Allow", style: UIAlertAction.Style.default) { ( action) in
              guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                  return
              }
              if UIApplication.shared.canOpenURL(settingsUrl) {
                  UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
              }
          }
          
          let dontAllow = UIAlertAction(title: "Don't Allow", style: UIAlertAction.Style.default) { ( action) in
            self.locationManager.startUpdatingLocation()
          }
          
          let locationPermissionMessage = Bundle.main.locationPermissionMessage
//          PISelectAddressViewController.showAlertView("Allow \"" + "\(Bundle.main.appName)" + "\" to access your location while you are using this app?", alertMessage: locationPermissionMessage, alertActionArr: [dontAllow, allow], presentingView: self)
      }
}

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
