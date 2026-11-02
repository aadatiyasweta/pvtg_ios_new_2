

import UIKit
import AVFoundation
import SVProgressHUD

class BaseViewController: UIViewController , AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate , UIGestureRecognizerDelegate{
    
    var emptyView:UIView!
    @IBOutlet weak var navBarView:UIView!
    var apiType = ""
    static let loaderView:UIView = {
        let view = UIView.init(frame: UIScreen.main.bounds)
        view.backgroundColor = .clear
        return view
    }()
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    @objc func methodOfReceivedNotification(notification: Notification) {
//        let info = notification.userInfo
//        appDelegate.performAttendingAlert(name : info?["name"] as? String ?? "", id : info?["session_id"] as? String ?? "")
//    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    func addSwipeGesture() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    // Screens that must not go back with a swipe (e.g. after payment) override this and return false
    var allowsSwipeBack: Bool {
        return true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addSwipeGesture()
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let navigation = self.navigationController, gestureRecognizer == navigation.interactivePopGestureRecognizer else { return true }
        // No swipe back on the first screen of a flow (nothing to go back to, and it can freeze the screen)
        guard navigation.viewControllers.count > 1 else { return false }
        // The main tabs are shown on top of Login / sign-up screens, so swiping back would leave the logged-in app
        if navigation.topViewController is UITabBarController { return false }
        return (navigation.topViewController as? BaseViewController)?.allowsSwipeBack ?? true
    }
    
    @objc func hidePlusButton() {
    }
    
    @objc func showPlusButton() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setupLayers(){
    }
    
    func drawLayers() {
    }
    
    func showWithTouch(){
           if isConnection(){
               SVProgressHUD.show()
           }
       }
       func hideWithTouch(){
           SVProgressHUD.dismiss()
       }
    
    func showDisableLoadingView() {
        self.view.addSubview(BaseViewController.loaderView)
        SVProgressHUD.show()
    }
    
    func hideDisableLoadingView() {
        BaseViewController.loaderView.removeFromSuperview()
        SVProgressHUD.dismiss()
    }
    
    func addRefresControl(tblView : UITableView){
        refreshControl.tintColor = #colorLiteral(red: 0.7369757891, green: 0.3353089094, blue: 0.2299287617, alpha: 1)
        refreshControl.addTarget(self, action: #selector(refreshControllChanged), for: .valueChanged)
        tblView.refreshControl = refreshControl
    }
    
    @objc func refreshControllChanged(refreshControl: UIRefreshControl) {
        debugPrint("Hello World!")
    }
    
    func getBackNavigationItem()->UIBarButtonItem{
        let backButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(clickOnBackButton))
        backButton.tintColor = .white
        return backButton
    }
    @objc func clickOnBackButton(){
        if self.navigationController?.popViewController(animated: true) == nil {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func clickOnBack() {
        if self.navigationController?.popViewController(animated: true) == nil {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func getBookmarkNavigationItem()->UIBarButtonItem{
        let bookMarkBtn = UIBarButtonItem.init(image: #imageLiteral(resourceName: "bookmark"), style: .plain, target: self, action: #selector(clickOnBookmarkButton))
        bookMarkBtn.tintColor = themeColor
        return bookMarkBtn
    }
    
    @objc func clickOnBookmarkButton(){
    }
    
    func showAlertView(_ msg: Any, title: String)  {
        let alertController = UIAlertController(title: "ALERT!", message: msg as? String, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: R.string.localizable.okButton(), style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertWithConfirmation(_ message: String, withTitle title: String, itsController controller: UIViewController,okBtn : String? = R.string.localizable.ok(),cancelBtn : String? = R.string.localizable.cancel(),completion completionBlock: @escaping (_ success: Bool) -> Void) {
        let alrt = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: R.string.localizable.ok(), style: .default, handler: {(_ alert: UIAlertAction) -> Void in
            completionBlock(true)
        })
        let Cancel = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            completionBlock(false)
        })
        
        let attributedTitle = NSAttributedString.init(string: title, attributes: [NSAttributedString.Key.font:getFont(Fonts.semiBold.rawValue, 16)!])
        
        let attributedMessage = NSAttributedString.init(string: message, attributes: [NSAttributedString.Key.font:getFont(Fonts.regular.rawValue, 14)!])
        
        alrt.setValue(attributedTitle, forKey: "attributedTitle")
        alrt.setValue(attributedMessage, forKey: "attributedMessage")
        
        alrt.addAction(ok)
        alrt.addAction(Cancel)
        controller.present(alrt, animated: true, completion: nil)
    }
 
 func showAlertWithConfirmation2(_ message: String, withTitle title: String, itsController controller: UIViewController,okBtn : String? = R.string.localizable.yes(),cancelBtn : String? = R.string.localizable.no(),completion completionBlock: @escaping (_ success: Bool) -> Void) {
     let alrt = UIAlertController(title: title, message: message, preferredStyle: .alert)
     let ok = UIAlertAction(title: R.string.localizable.ok(), style: .default, handler: {(_ alert: UIAlertAction) -> Void in
         completionBlock(true)
     })
     let Cancel = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
         completionBlock(false)
     })
     
     let attributedTitle = NSAttributedString.init(string: title, attributes: [NSAttributedString.Key.font:getFont(Fonts.semiBold.rawValue, 16)!])
     
     let attributedMessage = NSAttributedString.init(string: message, attributes: [NSAttributedString.Key.font:getFont(Fonts.regular.rawValue, 14)!])
     
     alrt.setValue(attributedTitle, forKey: "attributedTitle")
     alrt.setValue(attributedMessage, forKey: "attributedMessage")
     
     alrt.addAction(ok)
     alrt.addAction(Cancel)
     controller.present(alrt, animated: true, completion: nil)
 }
    
    func showAlertWithConfirmation1(_ message: String, withTitle title: String, itsController controller: UIViewController, completion completionBlock: @escaping (_ success: Bool) -> Void) {
        let alrt = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: R.string.localizable.okButton(), style: .cancel, handler: {(_ alert: UIAlertAction) -> Void in
            completionBlock(true)
        })
        
        let attributedTitle = NSAttributedString.init(string: title, attributes: [NSAttributedString.Key.font:getFont(Fonts.bold.rawValue, 16)!])
        
        let attributedMessage = NSAttributedString.init(string: message, attributes: [NSAttributedString.Key.font:getFont(Fonts.regular.rawValue, 14)!])
        
        alrt.setValue(attributedTitle, forKey: "attributedTitle")
        alrt.setValue(attributedMessage, forKey: "attributedMessage")
        
        alrt.addAction(ok)
        controller.present(alrt, animated: true, completion: nil)
    }
}

@IBDesignable class UIViewX:UIButton {
    
    @IBInspectable var border:CGFloat = 1.0 {
        didSet{
            self.setuppp()
        }
    }
    
    @IBInspectable var borderColour:UIColor = .white {
        didSet{
            self.setuppp()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setuppp() {
        self.layer.borderWidth = border
        self.layer.borderColor = borderColour.cgColor
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height/2
    }
}
