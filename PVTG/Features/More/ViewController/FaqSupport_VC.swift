//
//  FaqSupport_VC.swift
//  IDeals
//
//  Created by Rishabh on 30/08/19.
//  Copyright © 2019 Techugo. All rights reserved.
//

import UIKit

class FaqSupport_VC: UIViewController {

    
    @IBOutlet weak var tbl_faqSupport: UITableView!
    @IBOutlet weak var lbl_FaqSupport: UILabel!
    
    var selectedRow = -1
//    var setting_VM = SettingViewModel()
//    var arr_faqSupport = [FaqResult]()
//    var arr_Faq = [String: [Faq]]()
//    var arr_FaqData = [Faq]()
    var arr_Section = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toRegisterFaqSectionCell()
        toLocalizStoryBoarddata()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //setVSViewShadow(radius: 10, color: .black, view: self.btnBack, opacity: 0.12)

    }

    func toLocalizStoryBoarddata(){
        //lbl_FaqSupport.text = "FAQ's".localiz()
    }
    
    func toRegisterFaqSectionCell(){
         tbl_faqSupport.register(UINib.init(nibName: "FaqSectionCell", bundle: nil), forCellReuseIdentifier: "FaqSectionCell")
    }
    
//    func toCollectTheSectionData(data: [FaqResult]){
//        for i in 0..<data.count{
//            arr_Section.append(data[i].type ?? "")
//        }
//        _ = self.arr_Section.enumerated().map({ (offset,element) in
//            arr_Faq.updateValue(arr_FaqData, forKey: element)
//        })
//    }
    
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension FaqSupport_VC: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return  arr_faqSupport[section].faq?.count ?? 0
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableCell(withIdentifier: "FaqSectionCell") as! FaqSectionCell
//        headerView.bindDataUsingDate(dateStr: mySectionArray[section])
        //headerView.toSetSectionData(data: arr_faqSupport[section].type ?? "")
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FaqSupport_TVC", for: indexPath) as! FaqSupport_TVC
      //  let filter_DAta = arr_faqSupport[indexPath.section].faq![indexPath.row]
        
        
        
//        guard let dataList = filter_DAta?[indexPath.row] else{
//            return UITableViewCell()
//        }

       // cell.toSetQuery(data: filter_DAta)
     
//        if indexPath.row == selectedRow{
//
//            cell.lbl_Answers.text = filter_DAta.answer
//            cell.img_dropdown.image = #imageLiteral(resourceName: "drop")
//        }else{
//            cell.lbl_Answers.text = ""
//            cell.img_dropdown.image = #imageLiteral(resourceName: "dropdown")
//        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
//        return 100
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

