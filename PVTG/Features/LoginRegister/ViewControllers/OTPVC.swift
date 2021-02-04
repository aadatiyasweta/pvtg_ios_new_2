//
//  OTPVC.swift
//  NPNGUserApp
//
//  Created by Techugo on 12/08/20.
//  Copyright © 2020 Techugo. All rights reserved.
//

import UIKit
import SVPinView



class OTPVC: BaseViewController {
    
    //MARK:-  IBOutlets
    @IBOutlet weak var otpMobileLbL: UILabel!
    @IBOutlet weak var resndBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pinView: SVPinView!
    @IBOutlet weak var donotReciveLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    //    MARK:- Variables
    var mobNo = ""
    var code = "+91"
    var otp = ""
    var otpTimer : Timer?
    var counter = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // initialtimer()
        setupPinView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        self.view.layoutIfNeeded()
        setVSViewShadow(radius: 10, color: .black, view: self.btnBack, opacity: 0.12)
    }
    //MARK:- Timer
    func initialtimer(){
        self.resndBtn.alpha = 0
        self.donotReciveLbl.alpha = 0
        self.otpTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
    }
    
    
    @objc func timerAction() {
        if(counter > 0){
            self.counter -= 1
            self.resndBtn.alpha = 0
            self.donotReciveLbl.alpha = 0
         //   self.timeLbl.text = "00:\(String(format: "%02d", counter)) "+sec
        }else{
            otpTimer?.invalidate()
            self.resndBtn.alpha = 1
            self.donotReciveLbl.alpha = 1
            //self.timeLbl.text = "00:\(String(format: "%02d", counter)) "+sec
            self.timeLbl.text = ""
        }
    }
    
    
    func setupPinView() {
        pinView.pinLength = 4
        pinView.interSpace = 8
        pinView.textColor = UIColor.black
        pinView.style = .underline
        pinView.borderLineColor = #colorLiteral(red: 0.7921568627, green: 0.7921568627, blue: 0.7921568627, alpha: 1)
        pinView.activeBorderLineColor = #colorLiteral(red: 0.01960784314, green: 0.8509803922, blue: 0.7411764706, alpha: 1)
        pinView.borderLineThickness = 1
        pinView.activeBorderLineThickness = 1
        pinView.fieldBackgroundColor = .white
        pinView.activeFieldBackgroundColor = .white
        pinView.font = getFont(Fonts.semiBold.rawValue, 14)!
        pinView.keyboardType = .phonePad
        pinView.becomeFirstResponderAtIndex = 0
        pinView.didChangeCallback = { [weak self] pin in
            debugPrint(pin)
        }
        pinView.didFinishCallback = { [weak self] pin in
            self?.otp = pin
            self?.otpTimer?.invalidate()
           // self?.otpVM.verifiedOtp(verificationCode: self?.otp ?? "", phone: "\((self?.code ?? "+91") + (self?.mobNo ?? ""))")
        }
    }
    
    @IBAction func resendBtnTap(_ sender: UIButton) {
        self.pinView.clearPin()
//        self.otpVM.getOtp(number: self.mobNo, code: self.code, isLoader: false)
//        showMesssgeWindow(msg: resentOTP)
    }
    
    @IBAction func verifyBtnTap(_ sender: UIButton) {
//        if self.otp == "" {
//            showMesssgeWindow(msg: enterTheOTP)
//        }else {
//            self.otpTimer?.invalidate()
//            otpVM.verifiedOtp(verificationCode: self.otp, phone: "\(self.code + self.mobNo)")
//        }
       // self.otpVM.validateCoach(username: self.mobNo, countryCode: self.code)
        if self.otp == "" {
            showAlertView(emptyOTP, title: "PVTG")
        } else {
        let vc = ChangepaswdVC.instance()
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

