//
//  SearchSessionVC.swift
//  PVTG
//
//  Created by Test Machine on 30/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit

class SearchSessionVC: BaseViewController {
    
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
    
    //MARK: - Properties
    var vm = SearchSessionViewModel()
    var catgryId = 0
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnClose.isHidden = false
        setShadowToView()
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
    }
}

//MARK: - TEXT FIELD DELEGATES
extension SearchSessionVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            if textField.text?.count ?? 0 == 1 {
            }
            else {
                if textField.text?.count ?? 0 > 0 {
                } else {
                }
            }
        }
        else {
            if textField.text?.count ?? 0 > 0 {
            } else {
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - TABLE VIEW DELEGATES AND DATASOURCE
extension SearchSessionVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SessionCell.ident, for: indexPath) as? SessionCell else { return UITableViewCell()}
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//MARK: - COLLECTION VIEW DELEGATE AND DATASOURCE
extension SearchSessionVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.ident, for: indexPath) as? SearchCell else { return UICollectionViewCell() }
        if catgryId == indexPath.row {
            cell.vwContainCatgry.backgroundColor = UIColor().coloWithHexString(hex: "#05D9BD")
            cell.vwContainCatgry.border(width: 0.3, color: UIColor().coloWithHexString(hex: "#27FFE2"))
        } else {
            cell.vwContainCatgry.backgroundColor = UIColor().coloWithHexString(hex: "#9a9a9a")
            cell.vwContainCatgry.border(width: 0.3, color: UIColor().coloWithHexString(hex: "#9a9a9a"))
        }
        cell.vwContainCatgry.layer.cornerRadius = 17
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = ""
        let label = UILabel(frame: CGRect.zero)
        label.text = text
        label.sizeToFit()
        return CGSize(width: label.frame.size.width + 26, height: 45)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if catgryId == indexPath.row {
            catgryId = -1
        } else {
            catgryId = indexPath.row
        }
        self.colectionVwCategory.reloadData()
        
    }
    
}
