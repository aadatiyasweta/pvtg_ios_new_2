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
    
    //MARK: - Outlets
    @IBOutlet weak var vwContainFeedField: UIView!
    @IBOutlet weak var vwRating: CosmosView!
    @IBOutlet weak var txtView: UITextView!
    
    //MARK: - Properties
    private var vm = RateViewModel()
    var sessionid = ""
    var bookingID = ""
    var placeholder = ""
   //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.delegate = self
        txtView.text = placeholder
        txtView.textColor = .white
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        borderTheView()
        if SaveToDefaults().getAppLang() ?? "en" == "en"{
            self.placeholder  = "Write something..."
        }else{
            self.placeholder = "Escribe algo..."
        }
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func BtnSubmitTap(_ sender: UIButton) {
        guard let userid = SaveToDefaults().getUserId() else {return}
        if self.vm.ratevalidation(rating: "\(self.vwRating.rating)", desc: self.txtView.text) {
            self.vm.sessionRatingApi(user_id: userid, session_id: sessionid, rating: "\(self.vwRating.rating)", feedback: self.txtView.text, booking_id: self.bookingID)
        }
    }
}

//MARK: - VIEW CONTROLLER EXTENSION
extension RateUsVC {
    private func borderTheView() {
            self.vwContainFeedField.layer.borderWidth = 0.3
            self.vwContainFeedField.layer.borderColor = UIColor().coloWithHexString(hex: "#000000").cgColor
            self.txtView.layer.borderColor = UIColor.white.cgColor
            self.txtView.layer.borderWidth = 0.3
    }
}

//MARK: - CUSTOM DELEGATE
extension RateUsVC: AfterSuccess {
    func reloadData() {
        self.navigationController?.popViewController(animated: true)
        debugPrint("After Success")
    }
}

extension RateUsVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == placeholder {
    textView.text = ""
    textView.textColor = .black
    }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
    textView.text = placeholder
    textView.textColor = UIColor.white
    } else {
    placeholder = textView.text
    }
    }
    
    func textViewDidChange(_ textView: UITextView) {
    placeholder = textView.text
    }
}
