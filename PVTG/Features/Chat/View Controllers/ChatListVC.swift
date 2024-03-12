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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   
    @IBAction func backButtonAction(_ sender: Any) {
        
    }
    
}


//extension ChatListVC: UITableViewDelegate, UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //let cell = UITableViewCell.dequeueReusableCell(withIdentifier: <#T##String#>)
//    }
//    
//    
//}
