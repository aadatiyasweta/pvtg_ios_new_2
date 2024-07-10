//
//  PrivacyPolicyVC.swift
//  NPNGUserApp
//
//  Created by Techugo on 19/08/20.
//  Copyright © 2020 Techugo. All rights reserved.
//

import UIKit
import WebKit


class PrivacyPolicyVC: BaseViewController,WKNavigationDelegate ,UIWebViewDelegate,WKUIDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var okBtnVw: UIView!
    
    @IBOutlet weak var cancelBookingVw: UIView!
    
    @IBOutlet weak var cancelBookingBtn: UIButton!
    
    
    //MARK: - Properties
    var type = ""
    let webView = WKWebView()
    var url = ""
    var timeStr = ""
    var ammountSTr = ""
    var useridStr = ""
    var sessionId = ""
    var bookingId = ""
    var payment_id = ""
    var isFromPartial = false
    
    var rescheduleCountStr = ""
    var isFromReschedule = false
    var isComingCancelBooking = false
    var vm = SessionDetailViewModel()
    var getChargeId = ""
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelBookingVw.isHidden = true
        self.titleLbl.text = type
        self.showWithTouch()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        if isFromReschedule == true{
            self.okBtnVw.isHidden = false
        }else{
            self.okBtnVw.isHidden = true
        }
        
        if(isComingCancelBooking == true){
            self.okBtnVw.isHidden = true
            cancelBookingVw.isHidden = false
            
//            showAlertWithConfirmation2(R.string.localizable.cancelTheBooking(), withTitle: "Confirm Booking Cancellation", itsController: self) { (succsss) in
//                if succsss{
//                    
//                    let time = self.timeStr
//                    let ammount = self.ammountSTr
//                    let fromattter1 = DateFormatter()
//                    fromattter1.dateFormat = "yyyy-MM-dd HH:mm"
//                    fromattter1.timeZone =  NSTimeZone(abbreviation: "GMT+0:00") as TimeZone?
//                    let endDate = fromattter1.date(from: time) ?? Date()
//                    let hours = getMinutesDifferenceFromTwoDates(start: getCurrentLocalDate(), end: endDate).hour ?? 0
//                    if hours < 2{
//                        if let id = SaveToDefaults().getUserId(){
//                            let ammount = self.ammountSTr
//                            if let n = NumberFormatter().number(from: ammount) {
//                                let floatPrice = CGFloat(truncating: n)
//                                let fiftenPercent = CGFloat((floatPrice*15)/100)
//                                let finalPrice = floatPrice-fiftenPercent
//                                self.vm.sessionCancelApi(user_id: self.useridStr, session_id: self.sessionId, booking_id: self.bookingId, isFromPartial: true, paymentId: self.payment_id, ammount: "\(finalPrice)")
//                            }
//                            
//                        }
//                    }else{
//                        if let id = SaveToDefaults().getUserId(){
//                            self.vm.sessionCancelApi(user_id: id, session_id: self.sessionId, booking_id: self.bookingId, isFromPartial: false, paymentId: self.vm.model?.payment_id ?? "", ammount: self.vm.model?.paid_amount ?? "")
//                        }
//                    }
//                }
//            }
            
        }
        cancelBookingBtn.layer.cornerRadius = cancelBookingBtn.frame.size.height/2
        cancelBookingBtn.clipsToBounds = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setVSViewShadow(radius: 10, color: .black, view: self.btnBack, opacity: 0.12)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = CGRect.init(x: 0, y: 0, width: self.subView.frame.size.width, height: self.subView.frame.size.height - 20)
        // webView.backgroundColor = .clear
        self.subView.addSubview(webView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.hideWithTouch()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.showWithTouch()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideWithTouch()
    }
    
    private func webView(_ webView: WKWebView, didFailLoadWithError error: Error) {
        print(error.localizedDescription)
    }
    
    private func webViewDidFinishLoad(_ webView: WKWebView) {
        print("webViewDidFinishLoad")
    }
    
    private func webViewDidStartLoad(_ webView: WKWebView) {
        print("webViewDidStartLoad")
    }
    
    @IBAction func okBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        //self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func cancelBookingBtnTapped(_ sender: Any) {
        if(isComingCancelBooking == true){

            
            showAlertWithConfirmation2(R.string.localizable.cancelTheBooking(), withTitle: "Confirm Booking Cancellation", itsController: self) { (succsss) in
                if succsss{
                    
                    let time = self.timeStr
                    //let ammount = self.ammountSTr
                    let fromattter1 = DateFormatter()
                    fromattter1.dateFormat = "yyyy-MM-dd HH:mm"
                    fromattter1.timeZone =  NSTimeZone(abbreviation: "GMT+0:00") as TimeZone?
                    let endDate = fromattter1.date(from: time) ?? Date()
                    let hours = getMinutesDifferenceFromTwoDates(start: getCurrentLocalDate(), end: endDate).hour ?? 0
                    if hours < 2{
                        if let id = SaveToDefaults().getUserId(){
                            let ammount = self.ammountSTr
                            if let n = NumberFormatter().number(from: ammount) {
                                let floatPrice = CGFloat(truncating: n)
                                let fiftenPercent = CGFloat((floatPrice*15)/100)
                                let finalPrice = floatPrice-fiftenPercent
                                self.vm.sessionCancelApi(user_id: id, session_id: self.sessionId, booking_id: self.bookingId, isFromPartial: true, paymentId: self.payment_id, ammount: "\(finalPrice)", chargeid: self.getChargeId)
                            }
                            
                        }
                    }else{
                        if let id = SaveToDefaults().getUserId(){
                            self.vm.sessionCancelApi(user_id: id, session_id: self.sessionId, booking_id: self.bookingId, isFromPartial: false, paymentId: self.vm.model?.payment_id ?? "", ammount: self.ammountSTr, chargeid: self.getChargeId)
                        }
                    }
                    self.isComingCancelBooking = false
                    self.cancelBookingBtn.setTitle("CANCELLED", for: .normal)
                }
            }
            
        }
    }
}
