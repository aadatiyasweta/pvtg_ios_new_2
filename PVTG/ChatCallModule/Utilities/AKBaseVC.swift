//
//  UIViewControllerExtension.swift
//  iServe School
//
//  Created by iServe lab on 08/04/19.
//  Copyright © 2019  iservelab. All rights reserved.
//

import UIKit

enum AKPageMode {
    case create
    case update
    case view
    case Privacy_Policy, About_Us, Terms_Conditions
    case toShowPlanDetails, toUpgradePlan
    case editMemberDetails
}

enum AKScreenMode {
    case AddMedicationPres
    case AddAppointment
    case base
}

class AKBaseVC: UIViewController {
    
    static var id: String {
        return String(NSStringFromClass(self).split(separator: ".").last!)
    }
    
    
    final lazy var pageMode: AKPageMode = .create
    
    private weak var keyboardDidShowNotificationObserver: NSObjectProtocol?
    private weak var keyboardDidHideNotificationObserver: NSObjectProtocol?
    
    //  override var preferredStatusBarStyle: UIStatusBarStyle {
    //    if UITraitCollection.current.userInterfaceStyle == .dark {
    //      return .lightContent
    //    }
    //    return .darkContent
    //  }
    
    // MARK: - VC EVENTS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.restorationIdentifier = AKBaseVC.id
        self.addDismissKeybaordEvent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setKeyboardObservers()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardObservers()
        self.view.endEditing(true)
    }
    
    //MARK: - NAVIGATION
    
    enum NavigationStyle {
        case push, present
    }
    
    func navigate<T: AKBaseVC>(
        toView: T.Type,
        of storyboard: UIStoryboard? = nil,
        animated: Bool = true,
        style: NavigationStyle = .push,
        _ completion: ((T)->())? = nil
    ){
        let sb = storyboard ?? self.storyboard!
        let vc = sb.instantiateViewController(withIdentifier: toView.id) as! T
        if self.navigationController != nil {
            switch style {
            case .push:
                self.navigationController?.pushViewController(vc, animated: animated)
            case .present:
                self.present(vc, animated: animated)
            }
            completion?(vc)
            return
        }
        completion?(vc)
        self.present(vc, animated: animated)
    }
    
    public func back<T: AKBaseVC>(
        toView: T.Type? = nil,
        of storyboard: UIStoryboard? = nil,
        animated: Bool = true,
        _ completion: ((T)->())? = nil
    ) {
        guard let nav = self.navigationController else {
            self.dismiss(animated: animated)
            if let nav = self.presentingViewController as? UINavigationController {
                completion?(nav.viewControllers.last as! T)
                return
            }
            completion?(self.presentingViewController as! T)
            return
        }
        if let toView = toView, let vc = nav.viewControllers.first(where: {$0.restorationIdentifier == toView.id}) as? T {
            nav.popToViewController(vc, animated: animated)
            completion?(vc)
        } else if let toView = toView, !(nav.viewControllers.contains(where: {$0.restorationIdentifier == toView.id})) {
            let sb = storyboard ?? self.storyboard!
            let vc = sb.instantiateViewController(withIdentifier: toView.id) as! T
            nav.pushViewController(vc, animated: animated)
        } else {
            nav.popViewController(animated: animated)
        }
    }
    
    //MARK: - KEYBOARD HANDLING
    private func setKeyboardObservers(){
        guard let keyboardHandler = self.keyboardHandler else { return }
        self.keyboardDidShowNotificationObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardDidShowNotification,
            object: nil,
            queue: .main
        ) { [weak self] (noti) in
            guard let self = self else {return}
            guard let userInfo = noti.userInfo else {return}
            guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
            let height = keyboardSize.cgRectValue.height - self.view.safeAreaInsets.bottom
            keyboardHandler(height)
            self.keyboardHeight = height
            self.toastBottom?.constant = -(self.keyboardHeight + 50)
        }
        
        self.keyboardDidHideNotificationObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardDidHideNotification,
            object: nil,
            queue: .main
        ) { [weak self] (noti) in
            guard let self = self else {return}
            keyboardHandler(0)
            self.keyboardHeight = 0
            self.toastBottom?.constant = -(self.keyboardHeight + 50)
        }
    }
    
    private func removeKeyboardObservers(){
        guard self.keyboardHandler != nil else { return }
        [
            self.keyboardDidShowNotificationObserver,
            self.keyboardDidHideNotificationObserver
        ].compactMap({$0}).forEach({NotificationCenter.default.removeObserver($0)})
    }
    
    private var keyboardHandler: ((CGFloat)->())?
    public func setKeyboard(handler: @escaping (CGFloat)->()){self.keyboardHandler = handler}
    private var keyboardHeight : CGFloat = 0
    
    
    //MARK: - AKAlert
    struct AKAlertConfig {
        let titles: [String]
        let configurations: (([UITextField])->())
    }
    public func showAlert(
        title: String?, message: String? = "",
        style: UIAlertController.Style = .alert, sourceView: UIView? = nil,
        textFieldsWith configurations: AKAlertConfig? = nil,
        actions: [UIAlertAction]? = nil
    ){
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        //    alert.view.tintColor = .PRIMARY_PINK
        if actions == nil || actions?.count == 0 {
            alert.addAction(UIAlertAction(title: "OK", style: .default))
        } else {
            actions?.forEach({alert.addAction($0)})
        }
        if let configs = configurations {
            var tfs: [UITextField]! = []
            for tag in 0..<configs.titles.count {
                alert.addTextField { (tf) in
                    tf.tag = tag
                    tf.placeholder = configs.titles[tag]
                    tfs.append(tf)
                }
            }
            configs.configurations(tfs)
        }
        alert.popoverPresentationController?.sourceView = sourceView
        if presentedViewController != nil {
            dismiss(animated: true) {
                self.present(alert, animated: true)
            }
        } else {
            self.present(alert, animated: true)
        }
    }
    
    //MARK: - AKToast
    
    private func setupToastView() -> UIView? {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        self.view.addSubview(v)
        
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
            v.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor, constant: 16),
            v.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        self.toastBottom = v.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -(keyboardHeight + 50))
        self.toastBottom?.isActive = true
        return v
    }
    
    private func setupToastTextView( _ toastView: UIView?) -> UITextView? {
        let tv = UITextView()
        tv.textAlignment = .center
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isScrollEnabled = false
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 12, weight: .regular) //.roboto(.Regular, of: 12)
        if let v = toastView {
            v.addSubview(tv)
            NSLayoutConstraint.activate([
                tv.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 8),
                tv.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -8),
                tv.topAnchor.constraint(equalTo: v.topAnchor, constant: 0),
                tv.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: 0)
            ])
        }
        return tv
    }
    
    private var hasToast = false
    private var storeToast: [(
        text: String,
        duration: Float,
        textColor: UIColor,
        bgColor: UIColor,
        handler: (()->())?
    )] = []
    private var toastBottom: NSLayoutConstraint?
    
    func showToast(
        _ text: String,
        duration forSeconds: Float = 1.5,
        textColor: UIColor = .white,
        bgColor: UIColor = .gray,
        handler: (()->())? = nil
    ) {
        if hasToast {
            self.storeToast.append((text: text, duration: forSeconds, textColor: textColor, bgColor: bgColor, handler: handler))
            return
        }
        self.hasToast = true
        weak var toastView = self.setupToastView()
        weak var toastTextLabel = self.setupToastTextView( toastView)
        
        toastTextLabel?.text = text
        toastTextLabel?.textColor = textColor
        
        toastView?.backgroundColor = bgColor
        self.view.layoutIfNeeded()
        let radius = (toastTextLabel?.frame.height ?? 0) / 2
        toastView?.layer.cornerRadius = radius < 20 ? radius : 20
        
        toastView?.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            toastView?.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.25, delay: TimeInterval(forSeconds), options: []) {
                toastView?.alpha = 0
            } completion: { [weak self] _ in
                guard let self = self else {return}
                toastTextLabel?.removeFromSuperview()
                toastView?.removeFromSuperview()
                toastTextLabel = nil
                toastView = nil
                self.hasToast = false
                handler?()
                if self.storeToast.count > 0 {
                    let dequeueToast = self.storeToast.removeFirst()
                    self.showToast(dequeueToast.text, duration: dequeueToast.duration, textColor: dequeueToast.textColor, bgColor: dequeueToast.bgColor, handler: dequeueToast.handler)
                }
            }
        }
    }
    
    public func addDismissKeybaordEvent() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func openPhoneDialPad(with number: String) {
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    
    
}

extension AKBaseVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension UINib {
    static func getNib(ident: String) -> UINib {
        return UINib(nibName: ident, bundle: nil)
    }
}
