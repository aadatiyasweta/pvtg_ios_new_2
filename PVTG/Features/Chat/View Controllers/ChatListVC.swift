//
//  ChatListVC.swift
//  PVTG
//
//  Created by Techugo on 27/02/24.
//  Copyright © 2024 ShubhamMacmini. All rights reserved.
//

import UIKit

class ChatListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var onlineLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ReceiverTVCell", bundle: nil), forCellReuseIdentifier: "ReceiverTVCell")
        tableView.register(UINib(nibName: "SenderTVCell", bundle: nil), forCellReuseIdentifier: "SenderTVCell")
        tableView.register(UINib(nibName: "DateHeaderTVCell", bundle: nil), forCellReuseIdentifier: "DateHeaderTVCell")
    }
    

   
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension ChatListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableCell(withIdentifier: "DateHeaderTVCell") as? DateHeaderTVCell else {return UIView()}
        return header
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverTVCell", for: indexPath) as? ReceiverTVCell else {return UITableViewCell()}
        return cell
    }
}
