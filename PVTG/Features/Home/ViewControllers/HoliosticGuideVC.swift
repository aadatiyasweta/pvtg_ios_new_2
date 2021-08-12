//
//  HoliosticGuideVC.swift
//  PVTG
//
//  Created by Test Machine on 22/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//
import UIKit

class HoliosticGuideVC: BaseViewController {
    
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
    //MARK:- Variables
    var vm = SearchSessionViewModel()
    var catgryId = 1
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.delegate = self
        setShadowToView()
        self.btnClose.isHidden = false
        self.colectionVwCategory.isPagingEnabled = true
        
        if let userid = SaveToDefaults().getUserId() {
        vm.getAllCategoryApi(user_id: userid)
        }
        loadApi(categoryid: "\(catgryId)", search: "", isloader: true)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func setShadowToView() {
        paddingTextfield(textfield: txfSearch)
        DispatchQueue.main.async {
            setVSViewShadow(radius: 10, color: .black, view: self.vwContainSearch, opacity: 0.12)
            
        }
    }
    
    @IBAction func btnCloseTap(_ sender: UIButton) {
        self.txfSearch.resignFirstResponder()
        self.txfSearch.text = ""
        loadApi(categoryid: "\(catgryId)", search: "", isloader: true)
        
    }
    
}

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
       // loadApi(categoryid: "\(catgryId)", search: textField.text ?? "", isloader: false)

        //searchVendor_API(searchText: textField.text ?? "")
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        loadApi(categoryid: "\(catgryId)", search: textField.text ?? "", isloader: false)

        // searchVendor_API(searchText: textField.text ?? "")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

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

extension HoliosticGuideVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vm.categorymodel?.result?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.ident, for: indexPath) as? SearchCell else { return UICollectionViewCell() }
        if indexPath.row == 0 {
            cell.leadingConstarintVw.constant = -22
            cell.traillingConstarintVw.constant = 0
        } else if indexPath.row == (self.vm.categorymodel?.result?.count ?? 0)-1 {
            cell.leadingConstarintVw.constant = 0
            cell.traillingConstarintVw.constant = -22
        } else {
            cell.leadingConstarintVw.constant = 0
            cell.traillingConstarintVw.constant = 0
        }
        if index == indexPath.row {
            cell.vwContainCatgry.backgroundColor = UIColor().coloWithHexString(hex: "#05D9BD")
            cell.searchCategorylbl.textColor = .white
            cell.vwContainCatgry.border(width: 0.3, color: UIColor().coloWithHexString(hex: "#27FFE2"))
            self.colectionVwCategory.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: false)
        } else {
            cell.vwContainCatgry.backgroundColor = .white
            cell.searchCategorylbl.textColor = UIColor().coloWithHexString(hex: "#9a9a9a")
            cell.vwContainCatgry.border(width: 0.3, color: UIColor().coloWithHexString(hex: "#9a9a9a"))
        }
        cell.setSearchData(data: self.vm.categorymodel?.result?[indexPath.row])
        cell.vwContainCatgry.layer.cornerRadius = 17
        return cell    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = self.vm.categorymodel?.result?[indexPath.row].category_name
        let label = UILabel(frame: CGRect.zero)
        label.text = text
        label.sizeToFit()
        if indexPath.row == (self.vm.categorymodel?.result?.count ?? 0)-1{
            return CGSize(width: label.frame.size.width + 48, height: 45)
        }
        return CGSize(width: label.frame.size.width + 26, height: 45)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //  self.txfSearch.text = ""
        if index == indexPath.row {
            //  index = -1
        } else {
            index = indexPath.row
            catgryId = Int(self.vm.categorymodel?.result?[indexPath.row].category_id ?? "1") ?? 0
            loadApi(categoryid: self.vm.categorymodel?.result?[indexPath.row].category_id ?? "1", search: self.txfSearch.text ?? "", isloader: true)
            self.colectionVwCategory.reloadData()
        }
        
        
    }
    
    func loadApi(categoryid: String, search: String, isloader: Bool) {
        if let userid = SaveToDefaults().getUserId(), let lat = SaveToDefaults().getLatitude(), let lng = SaveToDefaults().getLongtitude() {
            vm.searchSessionApi(user_id: userid, category_id: categoryid, latitude: "\(lat)", longitude: "\(lng)", search: search, isLoader: isloader)
            
        }
    }

}

extension HoliosticGuideVC: GetSearchSessionData {
    func colecnreloadData() {
        self.colectionVwCategory.reloadData()
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
