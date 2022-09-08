//
//  HoliosticGuideVC.swift
//  PVTG
//
//  Created by Test Machine on 22/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//
import UIKit

class HoliosticGuideVC: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var txfSearch: UITextField!{
        didSet {
            self.txfSearch.delegate = self
        }
    }
    @IBOutlet weak var vwContainSearch: UIView!
    @IBOutlet weak var colectionVwCategory: UICollectionView!{
        didSet {
            self.colectionVwCategory.dataSource = self
            self.colectionVwCategory.delegate = self
            self.colectionVwCategory.register(SearchCell.nib(), forCellWithReuseIdentifier: SearchCell.ident)
            self.colectionVwCategory.register(PriceCollCell.nib(), forCellWithReuseIdentifier: PriceCollCell.ident)
        }
    }
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var tblVwSession: UITableView!{
        didSet {
            self.tblVwSession.dataSource = self
            self.tblVwSession.delegate = self
            self.tblVwSession.register(SessionCell.nib(), forCellReuseIdentifier: SessionCell.ident)
        }
    }
    
    @IBOutlet weak var lblNoSession: UILabel!
    
    //MARK: - Properties
    var vm = SearchSessionViewModel()
    var catgryId = 1
    var index = 0
    var minimUmPrice = 0
    var maximimPrice = 0
    var origiMinPrice = 0
    var origiMaxPrice = 0
    var selectedCurrency = "COP"
    var isOpenPopUp = false
    var indexPathRow = 0
    var isSelectedFromFilter = false
    
    //MARK: - Properties
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.delegate = self
        setShadowToView()
        self.btnClose.isHidden = false
        self.colectionVwCategory.isPagingEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let userid = SaveToDefaults().getUserId() {
            vm.getAllCategoryApi(user_id: userid)
        }
    }
    
    func setShadowToView() {
        paddingTextfield(textfield: txfSearch)
        DispatchQueue.main.async {
            setVSViewShadow(radius: 10, color: .black, view: self.vwContainSearch, opacity: 0.12)
        }
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func btnCloseTap(_ sender: UIButton) {
        self.txfSearch.resignFirstResponder()
        self.txfSearch.text = ""
        loadApi(categoryid: "\(catgryId)", search: "", isloader: true)
    }
}

//MARK: - TEXT FIELD DELEGATES
extension HoliosticGuideVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            if textField.text?.count ?? 0 == 1 {
                loadApi(categoryid: "\(catgryId)", search: string, isloader: false)
                //  searchVendor_API(searchText: string)
            }
            else {
                if textField.text?.count ?? 0 > 0 {
                    loadApi(categoryid: "\(catgryId)", search: textField.text! + string, isloader: false)
                    //  searchVendor_API(searchText: textField.text! + string)
                } else {
                    loadApi(categoryid: "\(catgryId)", search: string, isloader: false)
                    //searchVendor_API(searchText: string)
                }
            }
        }
        else {
            if textField.text?.count ?? 0 > 0 {
                loadApi(categoryid: "\(catgryId)", search: textField.text! + string, isloader: false)
                // searchVendor_API(searchText: textField.text! + string)
            } else {
                loadApi(categoryid: "\(catgryId)", search: string, isloader: false)
                // searchVendor_API(searchText: string)
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        loadApi(categoryid: "\(catgryId)", search: textField.text ?? "", isloader: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - TABLE VIEW DELEGATES AND DATASOURCE
extension HoliosticGuideVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.model?.result?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SessionCell.ident, for: indexPath) as? SessionCell else { return UITableViewCell()}
        cell.lblPlaceName.numberOfLines = 1
        cell.setData(data: self.vm.model?.result?[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SessionDetailVC.instance()
        vc.sessionId = self.vm.model?.result?[indexPath.row].session_id ?? "0"
        vc.controllerId = 2
        SaveToDefaults().setSessionTimeId(name: self.vm.model?.result?[indexPath.row].session_image)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - COLLECTION VIEW DELEGATES AND DATASOURCE
extension HoliosticGuideVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            if self.vm.categorymodel?.result?.count ?? 0 == 0{
                return 0
            }
            return 1
        }
        return self.vm.categorymodel?.result?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PriceCollCell.ident, for: indexPath) as! PriceCollCell
            if self.isSelectedFromFilter{
                cell.priceLbl.text = "\(self.selectedCurrency)\(self.minimUmPrice)-\(self.selectedCurrency)\(self.maximimPrice)"
            }else{
                cell.priceLbl.text = R.string.localizable.priceFilter()
            }
            cell.priceView.layer.cornerRadius = 17
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.ident, for: indexPath) as? SearchCell else { return UICollectionViewCell() }
            if indexPath.row == 0 {
                cell.leadingConstarintVw.constant = -5
                cell.traillingConstarintVw.constant = 0
            } else{
                cell.leadingConstarintVw.constant = 0
                cell.traillingConstarintVw.constant = 0
                
            }
            if index == indexPath.row {
                cell.vwContainCatgry.backgroundColor = UIColor().coloWithHexString(hex: "#05D9BD")
                cell.searchCategorylbl.textColor = .white
                cell.vwContainCatgry.border(width: 0.3, color: UIColor().coloWithHexString(hex: "#27FFE2"))
                
            } else {
                cell.vwContainCatgry.backgroundColor = .white
                cell.searchCategorylbl.textColor = UIColor().coloWithHexString(hex: "#9a9a9a")
                cell.vwContainCatgry.border(width: 0.3, color: UIColor().coloWithHexString(hex: "#9a9a9a"))
            }
            cell.setSearchData(data: self.vm.categorymodel?.result?[indexPath.row])
            cell.vwContainCatgry.layer.cornerRadius = 17
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
            return CGSize(width: label.frame.size.width + 40, height: 34)
        }else{
            let text = self.vm.categorymodel?.result?[indexPath.row].category_name
            let label = UILabel(frame: CGRect.zero)
            label.text = text
            label.sizeToFit()
            if indexPath.row == 0{
                return CGSize(width: label.frame.size.width + 36, height: 45)
            }
            return CGSize(width: label.frame.size.width + 26, height: 45)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let priceView = PriceView.initWith(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
            priceView?.delegate = self
            if(self.selectedCurrency == "USD"){
                priceView?.seekView.maxValue = CGFloat(300)
            }else {
                priceView?.seekView.maxValue = CGFloat(600000)
            }
            priceView?.seekView.minValue = CGFloat(self.origiMinPrice)
            priceView?.seekView.selectedMaxValue = CGFloat(self.maximimPrice)
            priceView?.seekView.selectedMinValue = CGFloat(self.minimUmPrice)
            priceView?.maxValue = self.maximimPrice
            priceView?.minimumValue = self.minimUmPrice
            priceView?.currencyArr = self.vm.categorymodel?.currency_data ?? []
            appDelegate.window?.addSubview(priceView!)
            for val in 0..<(self.vm.categorymodel?.currency_data!.count)!{
                if self.vm.categorymodel?.currency_data?[val] == self.selectedCurrency{
                    priceView?.currentIndex = val
                    priceView?.pickerView.selectRow(priceView!.currentIndex, inComponent: 0, animated: true)
                    priceView?.pickerView.reloadAllComponents()
                    break
                }
            }
        }else{
            if index == indexPath.row {
            } else {
                index = indexPath.row
                self.indexPathRow = indexPath.row
                catgryId = Int(self.vm.categorymodel?.result?[indexPath.row].category_id ?? "1") ?? 0
                if self.isOpenPopUp{
                    loadApi(categoryid: "\(self.catgryId)", search: "", isloader: true,minPrice: self.minimUmPrice,maxprice: self.maximimPrice)
                }else{
                    print("category id is",self.vm.categorymodel?.result?[indexPath.row].category_id ?? "1")
                    loadApi(categoryid: self.vm.categorymodel?.result?[indexPath.row].category_id ?? "1", search: self.txfSearch.text ?? "", isloader: true)
                }
                
                self.colectionVwCategory.reloadData()
            }
        }
    }
    
    func loadApi(categoryid: String, search: String, isloader: Bool,minPrice : Int? = 0 , maxprice : Int? = 0) {
        if let userid = SaveToDefaults().getUserId(), let lat = SaveToDefaults().getLatitude(), let lng = SaveToDefaults().getLongtitude() {
            vm.searchSessionApi(user_id: userid, category_id: categoryid, latitude: "\(lat)", longitude: "\(lng)", search: search, isLoader: isloader,minPrice : minPrice , maxprice : maxprice,currency: self.selectedCurrency)
        }
    }
}

extension HoliosticGuideVC: GetSearchSessionData {
    func colecnreloadData() {
        self.origiMaxPrice = self.vm.categorymodel?.min_max_price?.max_price ?? 0
        self.origiMinPrice = self.vm.categorymodel?.min_max_price?.min_price ?? 0
        self.minimUmPrice = self.vm.categorymodel?.min_max_price?.min_price ?? 0
        self.maximimPrice = self.vm.categorymodel?.min_max_price?.max_price ?? 0
        if self.vm.categorymodel?.currency_data?.count ?? 0 > 0{
            self.selectedCurrency =  self.vm.categorymodel?.currency_data?[0] ?? ""
        }
        
        self.colectionVwCategory.reloadData()
        if self.vm.categorymodel?.result?.count ?? 0 > 0{
            self.catgryId = Int(self.vm.categorymodel?.result?[indexPathRow].category_id ?? "1") ?? 0
            print("category id is",Int(self.vm.categorymodel?.result?[0].category_id ?? "1") ?? 0)
            loadApi(categoryid: "\(self.catgryId)", search: "", isloader: true,minPrice: 0,maxprice: 0)
        }
    }
    
    func reloadData() {
        if vm.model?.result?.count ?? 0>0 {
            self.lblNoSession.text = ""
            self.lblNoSession.isHidden = true
        } else {
            self.lblNoSession.text = R.string.localizable.noSession()
            self.lblNoSession.isHidden = false
        }
        self.tblVwSession.reloadData()
    }
}

extension HoliosticGuideVC : getPriceSliderValues{
    func slidermaxMinValue(min: Int, max: Int, currency: String, isSelectedFromFilter: Bool) {
        self.maximimPrice = max
        self.minimUmPrice = min
        self.selectedCurrency = currency
        self.colectionVwCategory.reloadData()
        loadApi(categoryid: "\(self.catgryId)", search: self.txfSearch.text ?? "", isloader: true,minPrice: min,maxprice: max)
        self.isOpenPopUp = true
    }
    
    func resetFilter() {
        self.maximimPrice = 600000
        self.minimUmPrice = 0
        if let userid = SaveToDefaults().getUserId() {
            vm.getAllCategoryApi(user_id: userid)
        }
    }
    
}
