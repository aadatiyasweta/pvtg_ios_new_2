//
//  ChatBoxView.swift
//  reachout
//
//  Created by Anuj Techugo on 19/08/21.
//  Copyright © 2021 techugo. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import AVKit
import MobileCoreServices
import IQKeyboardManager
import SVProgressHUD
//import SVProgressHUD
class ChatBoxView: AKBaseVC,DelegatePlayVideo {
    
    //MARK: - IBOutlets
    @IBOutlet var servicePriceLbl: UILabel!
    @IBOutlet var serviceName: UILabel!
    @IBOutlet var serviceDate: UILabel!
    @IBOutlet var serviceView: UIView!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var imageVideoButton: UIButton!
    @IBOutlet weak var popHeading: UILabel!
    @IBOutlet weak var calcelButton: UIButton!
    @IBOutlet weak var camraButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var customeImageVideoPopup: UIView!
    @IBOutlet var typeView: UIView!
    @IBOutlet var hideView: UIView!
    @IBOutlet var profileName: UILabel!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var attchmentView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    //    @IBOutlet weak var adapter: ChatBoxTVAdapter!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTVBottom: NSLayoutConstraint!
    @IBOutlet weak var messageTV: UITextView!
    @IBOutlet weak var messageTVHeight: NSLayoutConstraint!
    @IBOutlet var onlineView: UIView!
    @IBOutlet weak var sendView: UIView!
    @IBOutlet var hederView: UIView!
    @IBOutlet weak var noChatLbl: UILabel!
    @IBOutlet var notavilableView: UILabel!
    @IBOutlet weak var mapBtn: UIButton!
    //MARK: - Variables
    var image = ""
    var name = ""
    var ticketNo = ""
    var user = "user"
    var otherUser = "vendor"
    var onlineStatus = "true"
    var notavilableSatus = false
    let viewModel = ChatBoxViewModel()
    var arrChatList = [MessageModel]()
    private let minHeight: CGFloat = 40
    private let maxHeight: CGFloat = 70
    var keyboardWillShow: NSObjectProtocol?
    var keyboardWillHide: NSObjectProtocol?
    let imagePickerController = UIImagePickerController()
    let videoPickerController = UIImagePickerController()
    var Source_Type = "image"
    var videoURL: URL?
    var videoStrLink = ""
    var reciverId = "13"
    var imageFlag = false
    var videoFlag = false
    var player: AVPlayer!
    var previouslyPlayingItem: AVPlayerItem?
    var previouslyPlayingBtn: UIButton?
    var isPlaying = false
    var offset = 1
    var apiHit = false
    var scrollTbl = true
    var queryStatus = ""
    var isFromBooking = false
    var servceNmae = ""
    var servicedat = ""
    var servicePrice = ""
    var serviceType = ""
    let locationManager = CLLocationManager()
    
    weak var playPauseObserver: NSObjectProtocol?
    private var selectedImagesData: [(data: Data,name: String,key: String,extension: String)] = []
    
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        hederView.dropShadow(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.25), offSet: CGSize(width: 1, height: 1))
        if notavilableSatus {
            typeView.isHidden = true
            notavilableView.isHidden = false
        }
        else{
            typeView.isHidden = false
            notavilableView.isHidden = true
        }
        IQKeyboardManager.shared().keyboardDistanceFromTextField = 20
       
        imagePickerController.delegate = self
        videoPickerController.delegate = self
        self.customeImageVideoPopup.layer.cornerRadius = 20
        self.customeImageVideoPopup.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        self.customeImageVideoPopup.layer.borderColor = UIColor(red: 0/255, green: 98/255, blue: 155/255, alpha: 1.0).cgColor
        self.customeImageVideoPopup.layer.borderWidth = 1.0
        self.galleryButton.layer.borderWidth = 1.0
//        if self.onlineStatus == "true"{
//            onlineView.backgroundColor = UIColor(hexString: "079B7F")
//        }
//        else{
//            onlineView.backgroundColor = UIColor(hexString: "CCCCCC")
//        }
        self.galleryButton.layer.borderColor = UIColor(red: 0/255, green: 98/255, blue: 155/255, alpha: 1.0).cgColor
        self.viewModel.view = self
        if self.ticketNo == ""{
            self.profilePic.isHidden = false
//            self.onlineView.isHidden = false
//            self.audioButton.isHidden = false
            self.imageVideoButton.isHidden = false
  //          self.otherUser = "vendor"
        }
        else{
//            self.audioButton.isHidden = true
            self.imageVideoButton.isHidden = true
            self.profilePic.isHidden = true
//            self.onlineView.isHidden = true
      //      self.otherUser = "Support"
            if queryStatus == "Resolved" {
                self.noChatLbl.isHidden = false
                self.sendView.isHidden = true
            }else {
                self.noChatLbl.isHidden = true
                self.sendView.isHidden = false
            }
        }
        profileName.text = self.name
        profilePic.sd_setImage(with: URL(string: self.image), placeholderImage: UIImage(named: "person"))
        self.messageTV.layer.cornerRadius = 20
        self.messageTV.layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 0.6).cgColor
        self.messageTV.layer.borderWidth = 1.0
        tableView.delegate = self
        tableView.dataSource = self
        messageTV.textColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
        
        
        self.viewModel.viewDidLoad(reciverId: self.reciverId,user: self.user, ticketNo: self.ticketNo,otherUser:self.otherUser)
//        keyboardWillHide = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main, using: keyboardWillHideHandler(noti:))
//
//        keyboardWillShow = NotificationCenter.default.addObserver(
//            forName: UIResponder.keyboardWillShowNotification,
//            object: nil,
//            queue: .main,
//            using: keyboardWillShowHandler(noti:)
//        )
        
//        if SocketHelper.shared.isConnected {
//            AppObject.startLoader(viewName: self.view)
//                SocketHelper.shared.initChat(s_id: UserDefaults.userID ?? 0, r_id: self.reciverId, user: self.user, otherUser: self.otherUser)
//                    SocketHelper.shared.getChatList(s_id: UserDefaults.userID ?? 0, r_id: Int(self.reciverId) ?? 0, ticketNo: self.ticketNo,offset: "\(self.offset)")
//                self.chat()
//        }
//        else{
        SocketHelper.shared.establishConnection(type: "connect")
     //   AppObject.startLoader(viewName: self.view)
        self.show()
        SocketHelper.shared.callBackConnect = { [weak self] in
            SocketHelper.shared.initChat(s_id: SaveToDefaults().getUserId() ?? "0", r_id: self?.reciverId ?? "", user: self?.user ?? "", otherUser: self?.otherUser ?? "")
            SocketHelper.shared.getChatList(s_id: SaveToDefaults().getUserId() ?? "0", r_id: self?.reciverId ?? "", ticketNo: self?.ticketNo ?? "",offset: self?.offset ?? 1)
            self?.chat()
        }
        
            
//        }
        
        player = AVPlayer()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel.viewWillDisappear()
    }
    
    func show(){
        if isConnection(){
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.clear)
        }
    }
    func dismiss(){
        SVProgressHUD.dismiss()
    }
   
    //MARK: - Functions Play Video
    func PlayVideoURL(url: String) {
        var videoURL = URL(string: url)
        if videoURL == nil {
            videoURL = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        }
        let player = AVPlayer(url: videoURL!)
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    //MARK: - Function Image Preview
    func ImageZoomUrl(url: String){
        var imageArray = [String]()
        imageArray.append(url)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImagePreviewView") as! ImagePreviewView
        vc.set(list: imageArray)
        //        self.navigationController?.PresentViewWithAnimation(controller: vc)
        self.present(vc, animated: true)
    }
    
    //MARK: - KeyBoard Handler
    func keyboardWillShowHandler(noti: Notification) {
        guard let userInfo = noti.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let height = keyboardSize.cgRectValue.height - self.view.safeAreaInsets.bottom
        UIView.animate(withDuration: 3, delay: 0, options: .curveEaseInOut) {
//            self.messageTVBottom.constant = height
        }
        
        //        DispatchQueue.main.async {
        //            self.tableView.scrollRectToVisible(.init(origin: .init(x: 0, y: self.tableView.contentSize.height - self.tableView.frame.size.height), size: self.tableView.frame.size), animated: false)
        //        }
    }
    
    func keyboardWillHideHandler(noti: Notification) {
//        self.messageTVBottom.constant = 0
    }
    
    
    func setChatPartner(id: Int, name: String, partnerImg: String?) {
        self.viewModel.partnerID = id
        self.viewModel.partnerName = name
        self.viewModel.partnerImage = partnerImg
    }
    
    //MARK: - IBActions
    @IBAction func hideAttchmentViewclick(_ sender: Any) {
        self.attchmentView.isHidden = true
        self.hideView.isHidden = true
        self.customeImageVideoPopup.isHidden = true
    }
    @IBAction private func backAction(_ sender: UIButton) {
        IQKeyboardManager.shared().keyboardDistanceFromTextField = 10
        if SocketHelper.shared.isConnected {
            SocketHelper.shared.disconnect(senderId: SaveToDefaults().getUserId() ?? "")
            self.back()
        }
        else{
            SocketHelper.shared.establishConnection(type: "disconnet")
            SocketHelper.shared.callBackConnectDisconnect = { [weak self] in
                SocketHelper.shared.disconnect(senderId: SaveToDefaults().getUserId() ?? "")
                self?.back()
            }
        }
    }
    
    @IBAction func attechmentButton(_ sender: Any) {
        self.attchmentView.isHidden = false
        self.hideView.isHidden = false
        
    }
    
    @IBAction func recordBtnAction(_ sender: UIButton) {
        //        self.navigate(toView: RecordAudioPopupView.self, style: .present)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RecordAudioPopupView") as! RecordAudioPopupView
        vc.reciverId = self.reciverId
        vc.user = self.user
        vc.ticketNo = self.ticketNo
        //        self.navigationController?.PresentViewWithAnimation(controller: vc)
        self.present(vc, animated: true)
    }
    
    @IBAction func imageBtnAction(_ sender: UIButton) {
        self.Source_Type = "image"
        self.imageClicked()
    }
    @IBAction func videoBtnAction(_ sender: UIButton) {
        self.Source_Type = "VideoMedia"
        self.loadImagePicker()
    }
    @IBAction func clickOnCancleButton(_ sender: Any) {
        self.customeImageVideoPopup.isHidden = true
    }
    @IBAction func clickOnGallaryUploadButton(_ sender: Any) {
//        if Source_Type == "image"{
//            AVCaptureDevice.authorizeVideo(completion: { (status) in
//                if (status == AVCaptureDevice.AuthorizationStatus.alreadyAuthorized) || (status == AVCaptureDevice.AuthorizationStatus.justAuthorized) {
//                    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
//                    {
//                        self.imagePickerController.delegate = self
//                        self.imagePickerController.sourceType = .photoLibrary;
//                        self.imagePickerController.allowsEditing = true
//                        self.present(self.imagePickerController, animated: true, completion: nil)
//                    }
//                }else{
//                    self.showAlertForCameraPermissionDenied()
//                }
//            })
//        }
//        else{
//            AVCaptureDevice.authorizeVideo(completion: { (status) in
//                if (status == AVCaptureDevice.AuthorizationStatus.alreadyAuthorized) || (status == AVCaptureDevice.AuthorizationStatus.justAuthorized) {
//                    self.videoPickerController.allowsEditing = false
//                    self.videoPickerController.sourceType = .photoLibrary
//                    self.videoPickerController.mediaTypes = [kUTTypeMovie as String]
//                    self.videoPickerController.modalPresentationStyle = .popover
//                    self.present(self.videoPickerController, animated: true, completion: nil)
//                }else{
//                    self.showAlertForCameraPermissionDenied()
//                }
//            })
//            
//        }
 //       self.customeImageVideoPopup.isHidden = true
    }
    @IBAction func clickOnCameraUploadButton(_ sender: Any) {
//        if Source_Type == "image"{
//            AVCaptureDevice.authorizeVideo(completion: { (status) in
//                if (status == AVCaptureDevice.AuthorizationStatus.alreadyAuthorized) || (status == AVCaptureDevice.AuthorizationStatus.justAuthorized) {
//                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                        self.imagePickerController.delegate = self
//                        self.imagePickerController.sourceType = .camera;
//                        self.imagePickerController.allowsEditing = true
//                        self.present(self.imagePickerController, animated: true, completion: nil)
//                    }
//                }else{
//                    self.showAlertForCameraPermissionDenied()
//                }
//            })
//        }
//        else{
//            AVCaptureDevice.authorizeVideo(completion: { (status) in
//                if (status == AVCaptureDevice.AuthorizationStatus.alreadyAuthorized) || (status == AVCaptureDevice.AuthorizationStatus.justAuthorized) {
//                    if UIImagePickerController.isSourceTypeAvailable(.camera)
//                    {
//                        self.videoPickerController.allowsEditing = false
//                        self.videoPickerController.sourceType = UIImagePickerController.SourceType.camera
//                        self.videoPickerController.videoQuality = .typeHigh
//                        self.videoPickerController.mediaTypes = [kUTTypeMovie as String]
//                        self.videoPickerController.modalPresentationStyle = .popover
//                        self.present(self.videoPickerController, animated: true, completion: nil)
//                    }
//                }else{
//                    self.showAlertForCameraPermissionDenied()
//                }
//            })
//            
//        }
//        self.customeImageVideoPopup.isHidden = true
    }
    @IBAction func sendMessageAction(_ sender: UIButton) {
        guard let message = self.messageTV.text, message != "Write here something...", message != "" else { return }
//        SocketHelper.shared.sendMessage(data: [
//            "s_id": "\(UserDefaults.userID ?? "0")",
//            "r_id": reciverId,
//            "msg": message,
//            "msg_type": "text",
//            "url": "",
//            "user_type":self.user,
//            "ticketNo":self.ticketNo
//        ])
        self.sendMeassage(msg:message,msg_type:"text",url:"",thumbnil:"",lat: 0.0, long: 0.0)
        self.messageTV.textColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
        self.messageTV.text = "Write here something..."
        updateMsgTVHeight()
    }
    
    
    @IBAction func mapBtnAction(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
    
    deinit {
        let notifications = [keyboardWillShow, keyboardWillHide].compactMap({$0})
        notifications.forEach({NotificationCenter.default.removeObserver($0)})
        
    }
    //MARK: - Handler action Audio File Play Pause
    @objc private func playPauseBtnHandler(_ sender: UIButton) {
        if self.previouslyPlayingBtn == nil { // first time play
            if let cell = tableView.cellForRow(at: .init(row: sender.tag, section: 0)) as? PartnerAudioTVCell {
                player.replaceCurrentItem(with: cell.playerItem)
                player.play()
                self.isPlaying = true
                self.previouslyPlayingBtn = cell.playPauseBtn
                self.previouslyPlayingBtn?.isSelected = true
            } else if let cell = tableView.cellForRow(at: .init(row: sender.tag, section: 0)) as? MyAudioTVCell {
                player.replaceCurrentItem(with: cell.playerItem)
                player.play()
                self.isPlaying = true
                self.previouslyPlayingBtn = cell.playPauseBtn
                self.previouslyPlayingBtn?.isSelected = true
            }
        } else if self.previouslyPlayingBtn == sender, isPlaying { // trying to pause same playing item
            player.pause()
            self.isPlaying = false
            self.previouslyPlayingBtn?.isSelected = false
            self.previouslyPlayingBtn = nil
        } else if self.previouslyPlayingBtn == sender, !isPlaying { // trying to play saame playing item
            player.play()
            self.isPlaying = true
            self.previouslyPlayingBtn?.isSelected = true
        } else if self.previouslyPlayingBtn != sender { // trying to play other item without pausing previous item
            if isPlaying {
                player.pause()
                self.isPlaying = false
                self.player.seek(to: .zero)
                self.previouslyPlayingBtn?.isSelected = false
            }
            if let cell = tableView.cellForRow(at: .init(row: sender.tag, section: 0)) as? PartnerAudioTVCell {
                player.replaceCurrentItem(with: cell.playerItem)
                player.play()
                self.isPlaying = true
                self.previouslyPlayingBtn = cell.playPauseBtn
                self.previouslyPlayingBtn?.isSelected = true
            } else if let cell = tableView.cellForRow(at: .init(row: sender.tag, section: 0)) as? MyAudioTVCell {
                player.replaceCurrentItem(with: cell.playerItem)
                player.play()
                self.isPlaying = true
                self.previouslyPlayingBtn = cell.playPauseBtn
                self.previouslyPlayingBtn?.isSelected = true
            }
        } else if self.previouslyPlayingBtn != sender, !isPlaying { // other item,
           
        }
        
        self.playPauseObserver = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            self.isPlaying = false
            self.previouslyPlayingBtn?.isSelected = false
            self.player.seek(to: .zero)
            guard let observer = self.playPauseObserver else {return}
            NotificationCenter.default.removeObserver(observer)
        }
    }
    //MARK: - Handler action Play Video And Image Preview
    @objc private func playVideoBtnHandler(sender: UIButton) {
        var videoURL = URL(string: self.arrChatList[sender.tag].url)
        if videoURL == nil {
            videoURL = URL(string: self.arrChatList[sender.tag].url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        }
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    @objc private func zoomImageBtnHandler(sender: UIButton) {
        var imageArray = [String]()
        imageArray.append(self.arrChatList[sender.tag].url)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImagePreviewView") as! ImagePreviewView
        vc.set(list: imageArray)
        self.present(vc, animated: true)
    }
    
    @objc private func openMap(sender: UIButton) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                    UIApplication.shared.openURL(NSURL(string:
                                                        "comgooglemaps://?saddr=&daddr=\(Double(arrChatList[sender.tag].lat ?? 0.0) ?? 0.0),\(Double(arrChatList[sender.tag].lat ?? 0.0) ?? 0.0)&directionsmode=driving")! as URL)
                    
                } else {
                    // if GoogleMap App is not installed
                    UIApplication.shared.openURL(NSURL(string:
                                                        "https://maps.google.com/?q=@\(Double(arrChatList[sender.tag].lat ?? 0.0) ?? 0.0),\(Double(arrChatList[sender.tag].lat ?? 0.0) ?? 0.0)&directionsmode=driving")! as URL)
                }
    }
}

// MARK: - TextView Delegate Method
extension ChatBoxView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        self.messageTV.text = self.messageTV.text == "Write here something..."
        ? nil
        : textView.text
        self.messageTV.textColor = self.messageTV.text == "Write here something..."
        ? UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
        : UIColor.black
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.starts(with: " ") {
            textView.text.removeFirst()
        }
        self.updateMsgTVHeight()
    }
    
    private func updateMsgTVHeight() {
        var height = self.messageTV.adjustedHeight + 24
        height = minHeight < height ? height : minHeight
        height = height < maxHeight ? height : maxHeight
        self.messageTVHeight.constant = height
        self.view.layoutIfNeeded()
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.messageTV.text = self.messageTV.text == "" || self.messageTV.text == nil
        ? "Write here something..."
        : textView.text
        self.messageTV.textColor = self.messageTV.text == "Write here something..."
        ? UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
        : UIColor.black
    }
}

// MARK: - Extension TableView Delegate Method
extension ChatBoxView : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrChatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if arrChatList[indexPath.row].sID == "\(UserDetails.userID ?? 0)" && arrChatList[indexPath.row]. == "user"{}
        if arrChatList[indexPath.row].sID == Int(SaveToDefaults().getUserId() ?? "0"), arrChatList[indexPath.row].msgType == .text {
            let cell = tableView.dequeueReusableCell(withIdentifier: MyMessageTVCell.id, for: indexPath) as! MyMessageTVCell
            cell.set(arrChatList[indexPath.row])
            return cell
        } else if arrChatList[indexPath.row].sID != Int(SaveToDefaults().getUserId() ?? "0"), arrChatList[indexPath.row].msgType == .text {
            let cell = tableView.dequeueReusableCell(withIdentifier: PartnerMessageTVCell.id, for: indexPath) as! PartnerMessageTVCell
            cell.set(arrChatList[indexPath.row])
            return cell
        } else if arrChatList[indexPath.row].sID == Int(SaveToDefaults().getUserId() ?? "0"), arrChatList[indexPath.row].msgType == .Audio {
            let cell = tableView.dequeueReusableCell(withIdentifier: MyAudioTVCell.id, for: indexPath) as! MyAudioTVCell
            cell.playPauseBtn.tag = indexPath.row
            cell.playPauseBtn.addTarget(self, action: #selector(playPauseBtnHandler), for: .touchUpInside)
            cell.set(arrChatList[indexPath.row])
            return cell
        } else if arrChatList[indexPath.row].sID != Int(SaveToDefaults().getUserId() ?? "0"), arrChatList[indexPath.row].msgType == .Audio {
            let cell = tableView.dequeueReusableCell(withIdentifier: PartnerAudioTVCell.id, for: indexPath) as! PartnerAudioTVCell
            cell.playPauseBtn.tag = indexPath.row
            cell.playPauseBtn.addTarget(self, action: #selector(playPauseBtnHandler), for: .touchUpInside)
            cell.set(arrChatList[indexPath.row])
            return cell
        }
        else if arrChatList[indexPath.row].sID == Int(SaveToDefaults().getUserId() ?? "0"), arrChatList[indexPath.row].msgType == .video {
            let cell = tableView.dequeueReusableCell(withIdentifier: MyVideoTVCell.id, for: indexPath) as! MyVideoTVCell
            cell.playBtn.tag = indexPath.row
            cell.playBtn.addTarget(self, action: #selector(playVideoBtnHandler(sender:)), for: .touchUpInside)
            cell.set(arrChatList[indexPath.row])
            return cell
        } else if arrChatList[indexPath.row].sID != Int(SaveToDefaults().getUserId() ?? "0"), arrChatList[indexPath.row].msgType == .video {
            let cell = tableView.dequeueReusableCell(withIdentifier: PartnerVideoTVCell.id, for: indexPath) as! PartnerVideoTVCell
            cell.playBtn.tag = indexPath.row
            cell.playBtn.addTarget(self, action: #selector(playVideoBtnHandler(sender:)), for: .touchUpInside)
            cell.set(arrChatList[indexPath.row])
            return cell
        }
        else if arrChatList[indexPath.row].sID == Int(SaveToDefaults().getUserId() ?? "0"), arrChatList[indexPath.row].msgType == .image {
            let cell = tableView.dequeueReusableCell(withIdentifier: MyImageTVCell.id, for: indexPath) as! MyImageTVCell
            cell.playButton.tag = indexPath.row
            cell.playButton.addTarget(self, action: #selector(zoomImageBtnHandler(sender:)), for: .touchUpInside)
            cell.set(arrChatList[indexPath.row])
            return cell
        }
        else if arrChatList[indexPath.row].sID == Int(SaveToDefaults().getUserId() ?? "0"), arrChatList[indexPath.row].msgType == .location {
            let cell = tableView.dequeueReusableCell(withIdentifier: MyLocationTVCell.id, for: indexPath) as! MyLocationTVCell
            cell.playBtn.tag = indexPath.row
            cell.playBtn.addTarget(self, action: #selector(openMap(sender:)), for: .touchUpInside)
            cell.set(arrChatList[indexPath.row])
            return cell
        }
        //        else if arrChatList[indexPath.row].sID != "\(loginMaster?.data?.user_id ?? 0)", arrChatList[indexPath.row].msgType == .image {
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: PartnerImageTVCell.id, for: indexPath) as! PartnerImageTVCell
            cell.playButton.tag = indexPath.row
            cell.playButton.addTarget(self, action: #selector(zoomImageBtnHandler(sender:)), for: .touchUpInside)
            cell.set(arrChatList[indexPath.row])
            return cell
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == tableView{
            if let visibleRows = self.tableView.indexPathsForVisibleRows! as? [IndexPath]{
                if visibleRows.count > 0{
                    if visibleRows[0].row == 0 {
                        scrollTbl = false
//                        if !apiHit {
//                            self.apiHit = true
//                            if SocketHelper.shared.isConnected {
//                                SocketHelper.shared.getChatList(s_id: SaveToDefaults().getUserId() ?? "0", r_id: self.reciverId, ticketNo: self.ticketNo,offset: self.offset)
//                            }
//                            else {
//                                SocketHelper.shared.establishConnection(type: "list")
//                                SocketHelper.shared.callBackConnectList = { [weak self] in
//                                    SocketHelper.shared.getChatList(s_id: SaveToDefaults().getUserId() ?? "0", r_id: self?.reciverId ?? "", ticketNo: self?.ticketNo ?? "",offset: self?.offset ?? 0)
//                                }
//                            }
//                                                  
//                        }
                    }
                }
            }
        }}
    func chat(){
        SocketHelper.shared.sendMessageClosure = { [weak self] chatData in
            if let chatData = chatData {
                self?.arrChatList.append(chatData)
                self?.tableView.reloadData()
                if self?.arrChatList.count ?? 0 > 0 {
                    self?.tableView.scrollToRow(at: IndexPath(row: (self?.arrChatList.count ?? 0) - 1, section: 0), at: .bottom, animated: true)
                }
            }
        }
        SocketHelper.shared.getChatListClosure = { [weak self] chatData in
            //            self?.arrChatList += chatData?.reversed() ?? [ChatResult]()
            self?.apiHit = true
            self?.hideView.isHidden = true
           // AppObject.stopLoader()
            self?.dismiss()
            if let chatData  = chatData {
                
                if chatData.isEmpty {
                    if self?.offset == 1 {
                        self?.arrChatList.removeAll()
                    }
                    self?.apiHit = true
                } else {
                    if self?.offset == 1 {
                        self?.arrChatList = chatData
                        self?.arrChatList.reverse()
                    } else {
                        let chatList = chatData.reversed()
                        self?.arrChatList.insert(contentsOf: chatList, at: 0)
                    }
                    self?.offset += 1
                    if chatData.count == 10 {
                        self?.apiHit = false
                    }
                    else{
                        self?.apiHit = true
                    }
                }
                
                self?.tableView.reloadData()
                if chatData.count > 0 {
                    if self?.scrollTbl == true {
                        self?.tableView.scrollToRow(at: IndexPath(row: (self?.arrChatList.count ?? 0) - 1, section: 0), at: .bottom, animated: false)
                    }
                    else{
                        self?.tableView.scrollToRow(at: IndexPath(row: chatData.count, section: 0), at: .top, animated: false)
                    }
                }
            }
        }
    }
    
}
// MARK: - Extension Image Picker Delegate Method
extension ChatBoxView:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imageClicked()
    {
        self.view.endEditing(true)
        self.customeImageVideoPopup.isHidden = false
        self.popHeading.text = "Select image from"
        
    }
    
    func showAlertForCameraPermissionDenied() {
//        let alertController = UIAlertController(title: "Camera/Photos Unavailable", message: "You have disabled your Camera/Photos permission. Please go to Settings -> "  + " -> Click On \(APP_NAME) -> Allow Camera access", preferredStyle: .alert)
//        let okAction = UIAlertAction(title:"Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
//        })
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true, completion: nil)
    }
    //MARK: - Image Picker
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if Source_Type == "VideoMedia"{
//            if let selectedVideo:URL = (info[UIImagePickerController.InfoKey.mediaURL] as? URL) {
//                if sizePerMB(url: videoURL) < 5 {
//                    videoFlag = true
//                    videoURL = selectedVideo
//                    uploadvedioApi(selectedImage: selectedVideo)
//                }
//                else{
//                    TUGHelpers.sharedInstance.showAlertWithTitle(messageBody: "Video size should be less than 5 MB" , controller: AppObject.window?.rootViewController ?? UIViewController())
//                }
//                
//            }
//        }
//        else{
//            if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
//            {
//                let imgData = NSData(data: (img).jpegData(compressionQuality: 1)!)
//                let imageSize: Int = imgData.count
//                if 5120 >= Double(imageSize) / 1024{
//                    imageFlag = true
//                    uploadImageApi(selectedImage: img)
//                }
//                else{
//                    TUGHelpers.sharedInstance.showAlertWithTitle(messageBody: "Image size should be less than 5 MB" , controller: AppObject.window?.rootViewController ?? UIViewController())
//                }
//            }
//            else if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//            {
//                let imgData = NSData(data: (pickedImage).jpegData(compressionQuality: 1)!)
//                let imageSize: Int = imgData.count
//                if 5120 >= Double(imageSize) / 1024{
//                    imageFlag = true
//                    uploadImageApi(selectedImage: pickedImage)
//                }
//                else{
//                    TUGHelpers.sharedInstance.showAlertWithTitle(messageBody: "Image size should be less than 5 MB" , controller: AppObject.window?.rootViewController ?? UIViewController())
//                }
//            }
//        }
//        dismiss(animated: true, completion: nil)
//        
//   }
    // MARK: - Upload Video
//    func uploadvedioApi(selectedImage: URL){
//            let asset = AVAsset(url: videoURL!)
//            let duration = asset.duration
//            let durationTime = CMTimeGetSeconds(duration)
//            guard lround(durationTime)<16 else {
//                TUGHelpers.sharedInstance.showAlertWithTitle(messageBody: "Your video can't be longer than 15 seconds" , controller: AppObject.window?.rootViewController ?? UIViewController())
//                self.videoFlag = false
//                self.attchmentView.isHidden = true
//                self.hideView.isHidden = true
//                return
//            }
//            AppObject.startLoader(viewName: self.view)
//            viewModel.callUploadChatMediaApi(media_type: "Video", images: UIImage(), audio: Data(), video: selectedImage, videoThum: videoSnapshot() ?? UIImage())
//            viewModel.successClosure = { [weak self] obj in
//                if self?.videoFlag == true {
//                    //                SocketHelper.shared.sendMessage(data: [
//                    //                    "s_id": "\(UserDefaults.userID ?? "0")",
//                    //                    "r_id": self?.reciverId ?? "",
//                    //                    "msg": "",
//                    //                    "msg_type": "video",
//                    //                    "url": obj.data?[0] ?? "",
//                    //                    "thumbnail": obj.data?[1] ?? "",
//                    //                    "user_type": self?.user ?? "",
//                    //                    "ticketNo": self?.ticketNo ?? ""
//                    //                ])
//                    self?.sendMeassage(msg:"",msg_type:"video",url:obj.data?[0] ?? "",thumbnil:obj.data?[1] ?? "")
//                    self?.videoFlag = false
//                    self?.attchmentView.isHidden = true
//                    self?.hideView.isHidden = true
//                }
//            }
//            viewModel.errorClosure = {
//                TUGHelpers.sharedInstance.showAlertWithTitle(messageBody: self.viewModel.errorString ?? "" , controller: AppObject.window?.rootViewController ?? UIViewController())
//            }
//        
//    }
    
    func uploadImageApi(selectedImage: UIImage){
//        viewModel.callUploadChatMediaApi(media_type: "Image", images: selectedImage, audio: Data(), video: URL(fileURLWithPath: ""), videoThum: UIImage())
//        AppObject.startLoader(viewName: self.view)
//        viewModel.successClosure = { [weak self] obj in
//            if self?.imageFlag == true {
//                SocketHelper.shared.sendMessage(data: [
//                    "s_id": "\(UserDefaults.userID ?? "0")",
//                    "r_id": self?.reciverId ?? "",
//                    "msg": "",
//                    "msg_type": "image",
//                    "url": obj.data?[0] ?? "",
//                    "user_type": self?.user ?? "",
//                    "ticketNo": self?.ticketNo ?? ""
//                ])
//                self?.sendMeassage(msg:"",msg_type:"image",url:obj.data?[0] ?? "",thumbnil:"")
//                self?.imageFlag  = false
//                self?.attchmentView.isHidden = true
//                self?.hideView.isHidden = true
//            }
//        }
//        viewModel.errorClosure = {
//            TUGHelpers.sharedInstance.showAlertWithTitle(messageBody: self.viewModel.errorString ?? "" , controller: self
//        }
//        
        
    }
    func curveView(imageview: UIImageView,radius: CGFloat){
        imageview.layer.cornerRadius = radius
        
    }
}
extension ChatBoxView {
    func sendMeassage(msg:String,msg_type:String,url:String,thumbnil:String,lat:Double,long:Double){
        if SocketHelper.shared.isConnected {
            SocketHelper.shared.sendMessage(data: [
                "s_id": Int(SaveToDefaults().getUserId() ?? "0") ?? 0,
                "r_id": Int(self.reciverId) ?? 0 ,
                "msg": msg,
                "msg_type": msg_type,
                "url": url,
                "thumbnail": thumbnil,
                "sender_type": self.user ,
                "ticketNo": self.ticketNo,
                "lat": lat,
                "long":long
            ])
        }
        else{
            SocketHelper.shared.establishConnection(type: "send")
            SocketHelper.shared.callBackConnectSendMessage = { [weak self] in
                SocketHelper.shared.initChat(s_id: SaveToDefaults().getUserId() ?? "0", r_id: self?.reciverId ?? "", user: self?.user ?? "", otherUser: self?.otherUser ?? "")
                SocketHelper.shared.sendMessage(data: [
                    "s_id": "\(SaveToDefaults().getUserId() ?? "0")",
                    "r_id": self?.reciverId ?? "",
                    "msg": msg,
                    "msg_type": msg_type,
                    "url": url,
                    "thumbnail": thumbnil,
                    "sender_type": self?.user ?? "",
                    "ticketNo": self?.ticketNo ?? "",
                    "lat": lat,
                    "long":long
                ])
            }
        }
    }
}
// MARK: - Extension Video Delegate Method
extension ChatBoxView{
    
    
    func loadImagePicker(){
        self.customeImageVideoPopup.isHidden = false
        self.popHeading.text = "Select Video from"
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        
        dismiss(animated: true, completion: nil)
        
    }
    
//    @objc func videoSaved(_ video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutableRawPointer){
//        if let theError = error {
//            Helpers.showAlert(strTitle: "error saving the video = \(theError)")
//        } else {
//            DispatchQueue.main.async(execute: { () -> Void in
//            })
//        }
//    }
    
    
    func videoSnapshot() -> UIImage? {
        let asset = AVURLAsset(url:videoURL! )
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
        
        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        }
        catch let error as NSError
        {
            PVTG.showAlert(strTitle: "Image generation failed with error \(error)")
            return nil
        }
    }
    
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
   
    
}
extension UIView {
    static var id: String {
        return String(NSStringFromClass(self).split(separator: ".").last!)
    }
//    var cornerRadius: CGFloat{
//        get{
//            return layer.cornerRadius
//        }
//        set{
//            layer.cornerRadius = newValue
//        }
//    }
    
//    var borderColor: UIColor? {
//        get {
//            return UIColor(cgColor: layer.borderColor!)
//        }
//        set {
//            layer.borderColor = newValue?.cgColor
//        }
//    }
//    var borderWidth: CGFloat{
//        get{
//            return layer.borderWidth
//        }
//        set{
//            layer.borderWidth = newValue
//        }
//    }
}
extension String{
    func localDate(inFormat: AKDataTimeFormat) -> (value: Date, string: String)? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        //finding current date format of UTC date time in AKDataTimeFormat
        var utcDate: Date?
        for format in AKDataTimeFormat.allCases {
            formatter.dateFormat = format.rawValue
            if let date = formatter.date(from: self) {
                utcDate = date
                break
            }
        }
        guard let utcDate = utcDate else {
            return nil
            //      return (value: Date(), string: self)
        }
        
        //converting UTC date time into local
        
        formatter.dateFormat = inFormat.rawValue
        formatter.timeZone = .current
        var localDateStr = formatter.string(from: utcDate)
        guard let localDate = formatter.date(from: localDateStr) else {
            fatalError(">>>>> Error: Local conversion failed from UTC")
        }
        
        if inFormat.rawValue.contains("(dd)") {
            localDateStr =  addThWithDay(format: "dd", localDate: localDate, localDateStr: localDateStr)
        } else if inFormat.rawValue.contains("(d)") {
            localDateStr = addThWithDay(format: "d", localDate: localDate, localDateStr: localDateStr)
        }
        
        return (localDate, localDateStr)
    }
    func addThWithDay(format: String,localDate:Date,localDateStr:String) -> String {
        let f = DateFormatter()
        f.dateFormat = format
        let d = Int(f.string(from: localDate))!
        var temp = f.string(from: localDate)
        
        switch (d % 10) {
        case 1: temp = d == 11 ? "\(d)th" : "\(d < 10 ? "0" : "")\(d)st"
        case 2: temp = d == 12 ? "\(d)th" : "\(d < 10 ? "0" : "")\(d)nd"
        case 3: temp = d == 13 ? "\(d)th" : "\(d < 10 ? "0" : "")\(d)rd"
        default: temp = "\(d < 10 ? "0" : "")\(d)th"
        }
        return localDateStr.replacingOccurrences(of: "(\(d < 10 ? "0" : "")\(d))", with: temp)
    }
}

extension UITextView {
    var adjustedWidth: CGFloat {
        let lbl : UILabel = UILabel(frame: CGRect(x: 0, y: 0 , width: CGFloat.greatestFiniteMagnitude, height: self.frame.width))
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        lbl.text = text
        lbl.font = font
        lbl.sizeToFit()
        return lbl.frame.width
    }
    var adjustedHeight: CGFloat {
        let lbl : UILabel = UILabel(frame: CGRect(x: 0, y: 0 , width: self.frame.width, height:  CGFloat.greatestFiniteMagnitude))
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        lbl.text = text
        lbl.font = font
        lbl.sizeToFit()
        return lbl.frame.height
    }
}

extension ChatBoxView: CLLocationManagerDelegate {
    // MARK: - CLLocationManagerDelegate
        
        // Delegate method called when location is updated
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            // Stop updating location to conserve battery
            manager.stopUpdatingLocation()
            
            // Get the latest location
            guard let location = locations.last else {
                return
            }
            
            // Extract latitude and longitude
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            // Now you have the latitude and longitude, you can send this information wherever you need
            print("Latitude: \(latitude), Longitude: \(longitude)")
            
            // Example: Send location to a server
            sendLocationToServer(latitude: latitude, longitude: longitude)
        }
        
        // Function to send location data to a server
        func sendLocationToServer(latitude: Double, longitude: Double) {
            // Implement your code to send location data to a server here
            self.sendMeassage(msg:"",msg_type:"location",url:"",thumbnil:"",lat: latitude, long: longitude)
        }
}
