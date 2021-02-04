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
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subView: UIView!
    
    @IBOutlet weak var btnBack: UIButton!
    
    
    var type = ""
    let webView = WKWebView()
    var url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.titleLbl.text = type
         self.showWithTouch()
        webView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        // webView.backgroundColor = .clear
        self.subView.addSubview(webView)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setVSViewShadow(radius: 10, color: .black, view: self.btnBack, opacity: 0.12)
        

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
}
