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
    var vm = LoginVM()

    private let resendWaitSeconds = 60
    private var totalSecond = 60
    private var timer: Timer?

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPinView()
        self.vm.delegate = self
        self.otpMobileLbL.text = R.string.localizable.entertheverificationcode(self.email)
        startTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Stop the countdown when the user goes back, so it doesn't keep running
        if isMovingFromParent || isBeingDismissed {
            timer?.invalidate()
        }
    }

    deinit {
        timer?.invalidate()
    }

    override func viewWillLayoutSubviews() {
        self.view.layoutIfNeeded()
        setVSViewShadow(radius: 10, color: .black, view: self.btnBack, opacity: 0.12)
    }

    //MARK: - RESEND COUNTDOWN
    // Counts down from 01:00; the "Resend Code" button appears once it reaches zero.
    private func startTimer() {
        timer?.invalidate()
        totalSecond = resendWai     tSeconds
        updateTimerUI()
        // [weak self] so the timer doesn't keep this screen in memory
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.totalSecond = max(self.totalSecond - 1, 0)
            self.updateTimerUI()
        }
    }

    private func updateTimerUI() {
        let waiting = totalSecond > 0
        timeLbl.text = waiting ? String(format: "%02d:%02d", totalSecond / 60, totalSecond % 60) : ""
        donotReciveLbl.text = waiting ? "" : R.string.localizable.otpDidntReceive()
        resndBtn.setTitle(waiting ? "" : R.string.localizable.otpResendCode(), for: .normal)
        resndBtn.isUserInteractionEnabled = !waiting
        if !waiting {
            timer?.invalidate()
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
        pinView.didChangeCallback = { pin in
            print("OTP digits entered:", pin.count)
        }
        pinView.didFinishCallback = { [weak self] pin in
            self?.otp = pin
        }
    }
    
    @IBAction func resendBtnTap(_ sender: UIButton) {
        self.pinView.clearPin()
        self.otp = ""
        self.vm.forgotApi(email: self.email, is_resend: "1")
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
        let alertController = UIAlertController(title: appName, message: R.string.localizable.otpInvalid(), preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: R.string.localizable.okButton(), style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
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
