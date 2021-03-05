//
//  SearchLocationVC.swift
//  PVTG
//
//  Created by Test Machine on 07/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit
import GooglePlaces

class SearchLocationVC: BaseViewController {

    @IBOutlet weak var vwContainSearch: UIView!
    @IBOutlet weak var lblRecentSearch: UILabel!
    @IBOutlet weak var txfSearch: UITextField!{
        didSet{
            txfSearch.delegate = self
        }
    }
    
    @IBOutlet weak var tblSearchLocn: UITableView!{
        didSet {
            tblSearchLocn.dataSource = self
            tblSearchLocn.delegate = self
            tblSearchLocn.register(SearchLocationCell.nib(), forCellReuseIdentifier: SearchLocationCell.ident)
        }
    }
    
    @IBOutlet weak var imgSearchIcon: UIImageView!
    
    @IBOutlet weak var lblNoLocation: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var vwShowGoogleLocation: UIView!
    
    private var placesClient: GMSPlacesClient!
    var name:String?
    var address: String?
    var vm = SearchLocationViewMpdel()
    var arr = [String]()
    var arrDict = [[String:String]]()
    private var tableView: UITableView?
    private var tableDataSource: GMSAutocompleteTableDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.delegate = self
        setShadowToView()
        renderTheColorOfImage()
        placesClient = GMSPlacesClient.shared()
        self.vwShowGoogleLocation.backgroundColor = .clear
        self.lblRecentSearch.isHidden = true
        self.lblNoLocation.isHidden = false
        self.lblNoLocation.text = "No Location searched yet."
        self.lblNoLocation.textColor = .white
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let locArr = SaveToDefaults().getLocationLateArr() {
            self.arrDict = locArr
//            for i in locArr {
//                arr.append(i)
//            }
            if arrDict.count>0 {
                self.lblRecentSearch.isHidden = false
                self.lblNoLocation.isHidden = true
           //     SaveToDefaults().setLocationArr(loc: locArr)
            } else {
                self.lblRecentSearch.isHidden = true
                self.lblNoLocation.isHidden = false
                self.lblNoLocation.text = "No Location searched yet."
                self.lblNoLocation.textColor = .white
            }
        }
    }
    override func clickOnBack() {
        super.clickOnBack()
       // SaveToDefaults().setformattedAddress(lat: self.txfSearch.text ?? "")
    }
    func setShadowToView() {
           paddingTextfield(textfield: txfSearch)
           DispatchQueue.main.async {
               setVSViewShadow(radius: 10, color: .black, view: self.vwContainSearch, opacity: 0.12)
                       setVSViewShadow(radius: 10, color: .black, view: self.vwShowGoogleLocation, opacity: 0.12)
                       
           }
       }
    
    func renderTheColorOfImage() {
        DispatchQueue.main.async {
            let myImage = UIImage(named: "group-3")
            let tintableImage = myImage?.withRenderingMode(.alwaysTemplate)
            self.imgSearchIcon.image = tintableImage
            self.imgSearchIcon.tintColor = UIColor().coloWithHexString(hex: "#525252")
            
            let backImg = UIImage(named: "minimalLeft2X")
             let tintableImageBack = backImg?.withRenderingMode(.alwaysTemplate)
            self.btnBack.setImage(tintableImageBack, for: .normal)
            self.btnBack.tintColor = .white
        }
    }

}

extension SearchLocationVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.vm.locationMode.count
       
        return arrDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchLocationCell.ident, for: indexPath) as? SearchLocationCell else { return UITableViewCell() }
        //cell.lblCityNmae.text = self.vm.locationMode[indexPath.row].formattedAddress
    
        cell.lblCityNmae.text = self.arrDict[indexPath.row]["name"]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.txfSearch.text = self.arrDict[indexPath.row]["name"]
        SaveToDefaults().setformattedAddress(lat: self.txfSearch.text ?? "")
        SaveToDefaults().setCity(value: self.arrDict[indexPath.row]["city"])
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(self.txfSearch.text ?? "") {
            placemarks, error in
            let placemark = placemarks?.first
            let lat = placemark?.location?.coordinate.latitude
            let lon = placemark?.location?.coordinate.longitude
            SaveToDefaults().setLatitude(lat: lat)
            SaveToDefaults().setLongtitude(lon: lon)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
}

extension SearchLocationVC: UITextFieldDelegate {
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
               if string == "" {
                   if textField.text?.count ?? 0 == 1 {
                    self.tableView?.removeFromSuperview()
                    self.vwShowGoogleLocation.isHidden = true
                   // self.vm.locationApi(query: string)
                      //  searchVendor_API(searchText: string)
                   }
                   else {
                       if textField.text?.count ?? 0 > 0 {
                        tableDataSource.sourceTextHasChanged(textField.text! + string)
                        // self.vm.locationApi(query: textField.text! + string)
                         //  searchVendor_API(searchText: textField.text! + string)
                       } else {
                        tableDataSource.sourceTextHasChanged(string)
                         //self.vm.locationApi(query: string)
                           //searchVendor_API(searchText: string)
                       }
                   }
               }
               else {
                   if textField.text?.count ?? 0 > 0 {
                    tableDataSource.sourceTextHasChanged((textField.text ?? "") + string)
                   // self.vm.locationApi(query: (textField.text ?? "") + string)

                  //  PlacesApi(text: textField.text! + string)
                      // searchVendor_API(searchText: textField.text! + string)
                   } else {
                    tableDataSource.sourceTextHasChanged(string)
                    // self.vm.locationApi(query: string)
                      // searchVendor_API(searchText: string)
                   }
               }
               return true
           }
           
           func textFieldDidBeginEditing(_ textField: UITextField) {
            self.txfSearch.text = ""
            self.vwShowGoogleLocation.isHidden = false
            self.vwShowGoogleLocation.backgroundColor = .clear
            tableDataSource = GMSAutocompleteTableDataSource()
            tableDataSource.delegate = self
            tableDataSource.tableCellBackgroundColor = .white
            tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.vwShowGoogleLocation.frame.size.width, height: self.vwShowGoogleLocation.frame.size.height))
            tableView?.delegate = tableDataSource
            tableView?.dataSource = tableDataSource

            vwShowGoogleLocation.addSubview(tableView ?? UITableView())


              // self.vm.locationApi(query: (textField.text ?? ""))
               //searchVendor_API(searchText: textField.text ?? "")
           }
           func textFieldDidEndEditing(_ textField: UITextField) {
            tableDataSource.sourceTextHasChanged(textField.text ?? "")
              // self.vm.locationApi(query: (textField.text ?? ""))
              // searchVendor_API(searchText: textField.text ?? "")
           }
           func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.tableView?.removeFromSuperview()
            self.vwShowGoogleLocation.isHidden = true
               textField.resignFirstResponder()
               return true
           }
        
}

extension SearchLocationVC: CallBackForLocationList {
    func loadLoactionList() {
        self.tblSearchLocn.reloadData()
    }
    
    
}

extension SearchLocationVC: GMSAutocompleteTableDataSourceDelegate {
  func didUpdateAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
    // Turn the network activity indicator off.
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
    // Reload table data.
    tableView?.reloadData()
  }

  func didRequestAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
    // Turn the network activity indicator on.
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    // Reload table data.
    tableView?.reloadData()
  }

  func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
   
    // Do something with the selected place.
    var city = ""
    for val in place.addressComponents ?? []{
        if val.type == "locality"{
            city = val.name
        }
    }
    print(place)
    print("Place name: \(place.name)")
    print("Place address: \(place.formattedAddress)")
    print("Place attributions: \(place.attributions)")
    guard let address = place.formattedAddress else {return}
    self.txfSearch.text = address
    for i in arr {
        if arr.contains(self.txfSearch.text ?? "") == false {
            arr.append(self.txfSearch.text ?? "")
        }
    }
    if arr.count == 0 {
         arr.append(self.txfSearch.text ?? "")
    }
    var dict : [String:String] = [:]
     dict["name"] = address
     dict["city"] = city
   
    if !self.arrDict.contains(dict){
         self.arrDict.append(dict)
    }
    SaveToDefaults().setCity(value: dict["city"])
    SaveToDefaults().setLocationLateArr(loc: self.arrDict)
    
    SaveToDefaults().setLocationArr(loc: arr)
    SaveToDefaults().setLatitude(lat: place.coordinate.latitude)
    SaveToDefaults().setLongtitude(lon: place.coordinate.longitude)
    SaveToDefaults().setformattedAddress(lat: address)
    self.tblSearchLocn.reloadData()
    txfSearch.resignFirstResponder()
    self.tableView?.removeFromSuperview()
    self.vwShowGoogleLocation.isHidden = true
    self.navigationController?.popViewController(animated: true)
  }

  func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
    // Handle the error.
    print("Error: \(error.localizedDescription)")
  }

  func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didSelect prediction: GMSAutocompletePrediction) -> Bool {
    return true
  }
    
    
}
