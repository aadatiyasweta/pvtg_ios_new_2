//
//  FaqSupport_VC.swift
//  IDeals
//
//  Created by Rishabh on 30/08/19.
//  Copyright © 2019 Techugo. All rights reserved.
//

import UIKit

class FaqSupport_VC: UIViewController {

    //MARK: - Oulets
    @IBOutlet weak var tbl_faqSupport: UITableView!
    @IBOutlet weak var lbl_FaqSupport: UILabel!
    
    //MARK: - Properties
    var selectedRow = -1
    var arr_Section = [String]()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        toRegisterFaqSectionCell()
        toLocalizStoryBoarddata()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    func toLocalizStoryBoarddata(){
    }
    
    func toRegisterFaqSectionCell(){
         tbl_faqSupport.register(UINib.init(nibName: "FaqSectionCell", bundle: nil), forCellReuseIdentifier: "FaqSectionCell")
    }

    //MARK: - BUTTON ACTION
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - TABLE VIEW DELEGATES AND DATASOURCE
extension FaqSupport_VC: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "FaqSectionCell") as! FaqSectionCell
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FaqSupport_TVC", for: indexPath) as! FaqSupport_TVC
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedRow == indexPath.row {
            selectedRow = -1
        } else {
            selectedRow = indexPath.row
        }
        tbl_faqSupport.reloadData()
    }
}

