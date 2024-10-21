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
    
    //MARK: - Outlets
    @IBOutlet weak var otpMobileLbL: UILabel!
    @IBOutlet weak var resndBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pinView: SVPinView!
    @IBOutlet weak var donotReciveLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    //MARK: - Properties
    var email = ""
    var otp = ""
//    var otpTimer : Timer?
//    var counter = 60
    var vm = LoginVM()
    
    var totalSecond = 60
    var timer:Timer?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        timer?.invalidate()
        setupPinView()
        self.vm.delegate = self
        self.otpMobileLbL.text = R.string.localizable.entertheverificationcode(self.email)
        donotReciveLbl.text = ""
        resndBtn.setTitle("", for: .normal)
        resndBtn.isUserInteractionEnabled = false
        timeLbl.text = "00:30"
        
//        donotReciveLbl.text = "donotReciveLbl"
//        resndBtn.setTitle("Resend Code", for: .normal)
        
        self.totalSecond = 30
        self.startTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        self.view.layoutIfNeeded()
        setVSViewShadow(radius: 10, color: .black, view: self.btnBack, opacity: 0.12)
    }
  
    //MARK:  - INITIAL TIMER
//    func initialtimer(){
//        self.resndBtn.alpha = 0
//        self.donotReciveLbl.alpha = 0
//        self.otpTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
//    }
    
    //MARK: - TIMER ACTION
//    @objc func timerAction() {
//        if(counter > 0){
//            self.counter -= 1
//            self.resndBtn.alpha = 0
//            self.donotReciveLbl.alpha = 0
//        }else{
//            otpTimer?.invalidate()
//            self.resndBtn.alpha = 1
//            self.donotReciveLbl.alpha = 1
//         }
//    }
    func startTimer(){
       timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }
    
    @objc func countdown() {
        var minutes: Int
        var seconds: Int

        if totalSecond == 0 {
            timer?.invalidate()
            timeLbl.text = ""
            //resendTimeLbl.textColor = UIColor.lightGray
            
            self.resndBtn.isUserInteractionEnabled = true
            donotReciveLbl.text = "Didn’t Receive? "
            resndBtn.setTitle("Resend Code", for: .normal)
        }else{
            donotReciveLbl.text = ""
            resndBtn.setTitle("", for: .normal)
            totalSecond = totalSecond - 1
            minutes = (totalSecond % 3600) / 60
            seconds = (totalSecond % 3600) % 60
            print(String(format: "%02d:%02d", minutes, seconds))
            timeLbl.text = "\(String(format: "%02d:%02d", minutes, seconds))"
            self.resndBtn.isUserInteractionEnabled = false
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
            print(pin)
        }
        pinView.didFinishCallback = { [weak self] pin in
            self?.otp = pin
        }
    }
    
    @IBAction func resendBtnTap(_ sender: UIButton) {
        self.pinView.clearPin()
        self.vm.forgotApi(email: self.email, is_resend: "1")
        donotReciveLbl.text = ""
        resndBtn.setTitle("", for: .normal)
        self.totalSecond = 30
        self.startTimer()
    }
    
    @IBAction func verifyBtnTap(_ sender: UIButton) {
        if self.otp == "" {
            showAlertView(emptyOTP, title: appName)
        } else {
            self.vm.otpCheckApi(email: self.email, otp: self.otp)
        }
    }
    
}

//MARK: - CUSTOM DELEGATE
extension OTPVC: AfterLoginSuccess {
    func inCorrectOtpMessage() {
        let alertController = UIAlertController(title: "Dharma", message: "Invalid OTP." as? String, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            self.pinView.clearPin()
            self.otp = ""
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func changePaswdSucces() {
         debugPrint("changePaswdSucces")
    }
    
    func loginSuccess() {
        debugPrint("loginSuccess")
    }
    
    func failure(msg: String) {
        debugPrint("failure")
    }
    
    func createNewuser() {
        debugPrint("createNewuser")
    }
    
    func forgotSuccess() {
        debugPrint("forgotSuccess")
    }
    
    func otpCheckSuccess() {
        self.timer?.invalidate()
        let vc = ChangepaswdVC.instance()
        vc.email = self.email
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
