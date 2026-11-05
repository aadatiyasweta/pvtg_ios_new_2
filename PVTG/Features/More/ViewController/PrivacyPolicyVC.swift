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
    var webView = WKWebView()
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
        
        // 1. Configure WebView with link detection
               let config = WKWebViewConfiguration()
               config.dataDetectorTypes = [.all]

               // 2. Initialize WebView with temporary zero frame
        self.webView = WKWebView(frame: .zero, configuration: config)
        self.webView.navigationDelegate = self

               // 3. Add WebView to subView
               self.subView.addSubview(webView)

        self.loadPage()
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
//        webView.frame = CGRect.init(x: 0, y: 0, width: self.subView.frame.size.width, height: self.subView.frame.size.height - 20)
//        // webView.backgroundColor = .clear
//        self.subView.addSubview(webView)
        webView.frame = CGRect(
                   x: 0,
                   y: 0,
                   width: self.subView.frame.size.width,
                   height: self.subView.frame.size.height - 20
               )

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
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        handlePageLoadFailure(error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        handlePageLoadFailure(error)
    }
    
    // Offline, the web view can stay blank for a long time before it reports a failure, so check first
    private func loadPage() {
        guard isConnection() else {
            showPageLoadFailure()
            return
        }
        if let url = URL(string: url) {
            self.webView.load(URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30))
        }
    }

    // Stops the spinner and lets the user retry, because a failed page never reaches didFinish
    private func handlePageLoadFailure(_ error: Error) {
        // A cancelled load isn't a failure, for example when another load has replaced it
        if (error as NSError).code == NSURLErrorCancelled { return }
        showPageLoadFailure()
    }

    private func showPageLoadFailure() {
        self.hideWithTouch()
        let message = isConnection() ? R.string.localizable.pageLoadFailed() : R.string.localizable.msgNoInternetConnection()
        let iconName = isConnection() ? "exclamationmark.circle" : "wifi.slash"
        self.showNoInternetView(in: self.subView, message: message, iconName: iconName) { [weak self] in
            self?.loadPage()
        }
    }
    
    private func webViewDidFinishLoad(_ webView: WKWebView) {
        print("webViewDidFinishLoad")
    }
    
    private func webViewDidStartLoad(_ webView: WKWebView) {
        print("webViewDidStartLoad")
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                    decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

           if let url = navigationAction.request.url,
              let scheme = url.scheme,
              url.absoluteString.contains("7298") || scheme == "mailto" {
               if url.absoluteString.contains("7298"){
//                   if UIApplication.shared.canOpenURL(URL(string: "tel:573217298771")!) {
//                       UIApplication.shared.open(URL(string: "tel:573217298771")!)
//                   }
                   openWhatsApp(phoneNumber: "+573217298771")
                   decisionHandler(.cancel)
               }else{
                   if UIApplication.shared.canOpenURL(url) {
                       UIApplication.shared.open(url)
                   }
                   decisionHandler(.cancel)
               }
           } else {
               decisionHandler(.allow)
           }
        print(navigationAction.request.url)
        print(navigationAction.request.url?.scheme)
       }
    func openWhatsApp(phoneNumber: String) {
        // Ensure phone number is formatted correctly
        let cleanPhoneNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let urlString = "https://wa.me/\(cleanPhoneNumber)"
        
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // WhatsApp not installed or invalid URL
            let alert = UIAlertController(title: "Error", message: "Cannot open WhatsApp. Please make sure it is installed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            if let topController = AppObject.window?.rootViewController {
                topController.present(alert, animated: true)
            }
        }
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
                                self.vm.cancellSuccesClosure = {
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                            
                        }
                    }else{
                        if let id = SaveToDefaults().getUserId(){
                            self.vm.sessionCancelApi(user_id: id, session_id: self.sessionId, booking_id: self.bookingId, isFromPartial: false, paymentId: self.vm.model?.payment_id ?? "", ammount: self.ammountSTr, chargeid: self.getChargeId)
                            self.vm.cancellSuccesClosure = {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                    self.isComingCancelBooking = false
                    self.cancelBookingBtn.setTitle("Cancelled", for: .normal)
                }
            }
            
        }
    }
}
