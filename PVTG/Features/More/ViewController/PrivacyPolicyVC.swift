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
    //MARK: - Properties
    var type = ""
    let webView = WKWebView()
    var url = ""
    var isFromReschedule = false
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
}
