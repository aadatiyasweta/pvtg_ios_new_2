//
//  RateUsVC.swift
//  PVTG
//
//  Created by Test Machine on 06/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit
import Cosmos

class RateUsVC: BaseViewController {
    //MARK:- IBOutlets
    
    @IBOutlet weak var vwContainFeedField: UIView!
    @IBOutlet weak var vwRating: CosmosView!
    @IBOutlet weak var txtView: UITextView!
    
     //MARK:- variables
    private var vm = RateViewModel()
    var sessionid = ""
    
    //MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        borderTheView()
    }
    
    //MARK:- IBActions
    @IBAction func BtnSubmitTap(_ sender: UIButton) {
        guard let userid = SaveToDefaults().getUserId() else {return}
        if self.vm.ratevalidation(rating: "\(self.vwRating.rating)", desc: self.txtView.text) {
            self.vm.sessionRatingApi(user_id: userid, session_id: sessionid, rating: "\(self.vwRating.rating)", feedback: self.txtView.text)
        }
    }
    
}

extension RateUsVC {
    //1:-Funtion For Bordering the views
    private func borderTheView() {
            self.vwContainFeedField.layer.borderWidth = 0.3
            self.vwContainFeedField.layer.borderColor = UIColor().coloWithHexString(hex: "#000000").cgColor
            self.txtView.layer.borderColor = UIColor.white.cgColor
            self.txtView.layer.borderWidth = 0.3
    }

}

extension RateUsVC: AfterSuccess {
    func reloadData() {
        self.navigationController?.popViewController(animated: true)
        debugPrint("After Success")
    }
    
    
}
