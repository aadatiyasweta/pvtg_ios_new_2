//
//  CountryPicker.swift
//  NPNGUserApp
//
//  Created by Techugo on 11/08/20.
//  Copyright © 2020 Techugo. All rights reserved.
//

protocol SelectCountryProtocol:class {
    func getAddressValues(code : String)
}
import UIKit

class CountryPicker: UIView ,UITableViewDelegate,UITableViewDataSource{
    
    //MARK: - Outlets
    @IBOutlet weak var lineView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countryField: UITextField!
    
    //MARK: - Properties
    var isSearching = false
    var filterCountry = [Country]()
    var country = [Country]()
    var countryCode = "+91"
    weak var delegateObj:SelectCountryProtocol?
    
    //MARK: - LifeCycle
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func initWith(frame: CGRect)->CountryPicker? {
        let view = Bundle.main.loadNibNamed("CountryPicker", owner: self, options: nil)?[0] as? CountryPicker
        view?.frame = frame
        view?.setUi()
        return view
    }
    
    func setUi(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(CountryCodeCell.nib(), forCellReuseIdentifier: CountryCodeCell.ident)
        self.setUpCountryCodes()
    }
    
    func setUpCountryCodes(){
        let bundle: Bundle = Bundle.main
        let resource: String = "CountryCode"
        let jsonPath = bundle.path(forResource: resource, ofType: "json")
        assert(jsonPath != nil, "Resource file is not found in the Bundle")
        let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath!))
        assert(jsonPath != nil, "Resource file is not found")
        do {
            if let jsonObjects = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray {
                self.country.removeAll()
                for jsonObject in jsonObjects{
                    let countryObj = jsonObject as? NSDictionary
                    let code = countryObj!["code"] as? String
                    let phoneCode = countryObj!["dial_code"] as? String
                    let name = countryObj!["name"] as? String
                    let counObj = Country.init(code: code, name: name, phoneCode: phoneCode, flag: flag(from: code ?? ""))
                    self.country.append(counObj)
                    self.tableView.reloadData()
                }
            }
        } catch let error {
            assertionFailure(error.localizedDescription)
        }
    }
    
    func flag(from country:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.uppercased().unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return s
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func searchFieldChnaged(_ sender: UITextField) {
        self.lineView.backgroundColor = #colorLiteral(red: 0.9376444221, green: 0.4206438661, blue: 0.3777168989, alpha: 1)
        if sender.isEmpty(){
            isSearching = false
        }
        else{
            isSearching = true
            filterCountry = country.filter({($0.name?.localizedCaseInsensitiveContains(sender.text!))!})
        }
        self.tableView.reloadData()
    }
    
    @IBAction func editngEnd(_ sender: UITextField) {
        self.lineView.backgroundColor = .lightGray
    }
    
    @IBAction func cancelBtnTap(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if self.isSearching{
           return self.filterCountry.count
       }
       return self.country.count
   }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCodeCell") as! CountryCodeCell
       if !self.isSearching{
       cell.codeLbl.text = self.country[indexPath.row].phoneCode
       cell.nameLbl.text = "\(self.country[indexPath.row].flag ?? "") \(self.country[indexPath.row].name ?? "")(\(self.country[indexPath.row].code ?? ""))"
       }
       else{
           cell.codeLbl.text = self.filterCountry[indexPath.row].phoneCode
           cell.nameLbl.text = "\(self.filterCountry[indexPath.row].flag ?? "") \(self.filterCountry[indexPath.row].name ?? "")(\(self.filterCountry[indexPath.row].code ?? ""))"
       }
       return cell
   }
    
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
   }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       if !self.isSearching{
           self.countryCode = self.country[indexPath.row].phoneCode!
       }
       else{
           self.countryCode = self.filterCountry[indexPath.row].phoneCode!
       }
       self.delegateObj?.getAddressValues(code: self.countryCode)
       self.removeFromSuperview()
   }
}

struct Country {
    var code: String?
    var name: String?
    var phoneCode: String?
    var flag : String?
    init(code: String?, name: String?, phoneCode: String?,flag : String) {
        self.code = code
        self.name = name
        self.phoneCode = phoneCode
        self.flag = flag
    }
}
