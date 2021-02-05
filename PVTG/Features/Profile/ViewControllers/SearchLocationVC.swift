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
    var SearchedLocation = [String]()
     var arrLoc = [String]()
    
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
        if let locArr = SaveToDefaults().getLocationArr() {
            if locArr.count>0 {
                self.lblRecentSearch.isHidden = false
                self.lblNoLocation.isHidden = true
            } else {
                self.lblRecentSearch.isHidden = true
                self.lblNoLocation.isHidden = false
                self.lblNoLocation.text = "No Location searched yet."
                self.lblNoLocation.textColor = .white
            }
        }
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
        guard let locArr = SaveToDefaults().getLocationArr() else {return 0}
        return locArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchLocationCell.ident, for: indexPath) as? SearchLocationCell, let locArr = SaveToDefaults().getLocationArr() else { return UITableViewCell() }
        //cell.lblCityNmae.text = self.vm.locationMode[indexPath.row].formattedAddress
        cell.lblCityNmae.text = locArr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let locArr = SaveToDefaults().getLocationArr() else {return}
        self.txfSearch.text = locArr[indexPath.row]
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
    print("Place name: \(place.name)")
    print("Place address: \(place.formattedAddress)")
    print("Place attributions: \(place.attributions)")
    guard let address = place.formattedAddress else {return}
    self.txfSearch.text = address
    arrLoc.append(self.txfSearch.text ?? "")
    SaveToDefaults().setLocationArr(loc: arrLoc)
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
