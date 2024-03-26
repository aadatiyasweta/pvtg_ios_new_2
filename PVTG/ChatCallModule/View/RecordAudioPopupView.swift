//
//  RecordAudioPopupView.swift
//  SocketAudioChat
//
//  Created by Anuj Kumar on 08/11/22.
//

import UIKit
import AVFoundation

class RecordAudioPopupView: AKBaseVC {
    //MARK: - IBOutlet
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    //MARK: - variables
    var reciverId = "13"
    var ticketNo = ""
    var user = ""
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var meterTimer: Timer!
    var isAudioRecordingGranted: Bool!
    var isRecording = false
    var isPlaying = false
    var audioFlag = false
    var fileUrl: URL!
    var viewModel = ChatBoxViewModel()
    //    var message: String?
    //MARK: - Lifecycle function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkRecordPermission()
    }
    //MARK: - IBAction
    @IBAction func deleteAudioBtnAction(_ sender: UIButton) {
        self.back()
    }
    
    @IBAction func playPauseRecordingBtnAction(_ sender: UIButton) {
        guard self.fileUrl != nil, !isRecording else {return}
        sender.isSelected.toggle()
        if isPlaying {
            audioPlayer.stop()
            isPlaying = false
        } else {
            if FileManager.default.fileExists(atPath: getFileUrl().path) {
                prepare_play()
                audioPlayer.play()
                meterTimer?.invalidate()
                meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector: #selector(self.updatePlayerMeter), userInfo:nil, repeats:true)
                isPlaying = true
            } else {
                self.showAlert(title: "Error", message: "Audio file is missing.")
            }
        }
    }
    
    @IBAction func stopStartRecordingBtnAction(_ sender: UIButton) {
        self.checkRecordPermission()
        if isAudioRecordingGranted {
            sender.isSelected.toggle()
            if isRecording {
                finishAudioRecording(success: true)
                isRecording = false
            } else {
                setupRecorder()
                audioRecorder.record()
                meterTimer?.invalidate()
                meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector: #selector(self.updateAudioMeter), userInfo:nil, repeats:true)
                isRecording = true
            }
        }
    }
    
    @IBAction func sendBtnAction(_ sender: UIButton) {
        self.audioFlag = true
        if isRecording {
            finishAudioRecording(success: true)
            isRecording = false
        }
        guard let url = self.fileUrl else { return }
        self.uploadFile(data: try? Data(contentsOf: url))
    }
}

//MARK: - AudioRecorder Methods
extension RecordAudioPopupView {
    
    func checkRecordPermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            isAudioRecordingGranted = true
        case AVAudioSession.RecordPermission.denied:
            isAudioRecordingGranted = false
            self.showAlertForAudioPermissionDenied()
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                if allowed {
                    self.isAudioRecordingGranted = true
                } else {
                    self.isAudioRecordingGranted = false
                    self.showAlertForAudioPermissionDenied()
                }
            })
        default:
            isAudioRecordingGranted = false
            self.showAlertForAudioPermissionDenied()
        }
    }
    
    func getFileUrl() -> URL {
        self.fileUrl = FileManager
            .default
            .urls (
                for: .documentDirectory,
                in: .userDomainMask
            ) [0].appendingPathComponent("myRecording.m4a")
        return self.fileUrl
    }
    
    func setupRecorder() {
        if isAudioRecordingGranted {
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(
                    AVAudioSession.Category.playAndRecord,
                    mode: .default, options: .defaultToSpeaker)
                try session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
                self.fileUrl = getFileUrl()
                audioRecorder = try AVAudioRecorder(url: self.fileUrl, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
            } catch let error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        } else {
            self.showAlert(title: "Error", message: "Don't have access to use your microphone.")
        }
    }
    
    @objc func updateAudioMeter(timer: Timer) {
        if audioRecorder.isRecording {
            let hr = Int((audioRecorder.currentTime / 60) / 60)
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            timerLbl.text = totalTimeString
            audioRecorder.updateMeters()
        }
    }
    
    @objc func updatePlayerMeter(timer: Timer) {
        if audioPlayer.isPlaying {
            let hr = Int((audioPlayer.currentTime / 60) / 60)
            let min = Int(audioPlayer.currentTime / 60)
            let sec = Int(audioPlayer.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            timerLbl.text = totalTimeString
            audioPlayer.updateMeters()
        }
    }
    
    func finishAudioRecording(success: Bool) {
        if success {
            audioRecorder.stop()
            audioRecorder = nil
            meterTimer.invalidate()
        } else {
            self.showAlert(title: "Error", message: "Recording failed.")
        }
    }
    
    func prepare_play() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: self.fileUrl)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        } catch {
            self.showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    func showAlertForAudioPermissionDenied() {
        let alertController = UIAlertController(title: "MicroPhone  Unavailable", message: "You have disabled your MicroPhone permission. Please go to Settings -> "  + " -> Click On \(appName) -> Allow MicroPhone access", preferredStyle: .alert)
        let okAction = UIAlertAction(title:"Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
        })
        alertController.addAction(okAction)
//        AppObject.window?.rootViewController?.present(alertController, animated: true)
    }
    
}

//MARK: - AudioRecorder Delegates
extension RecordAudioPopupView: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishAudioRecording(success: false)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playPauseBtn.isSelected = false
        //        self.timerLbl.text = "00:00:00"
        self.isPlaying = false
    }
}

//MARK: - APIs
extension RecordAudioPopupView {
    
    func uploadFile(data: Data?) {
        guard let data = data else {return}
        //        self.indicator.startAnimating()
      //  AppObject.startLoader(viewName: self.view)
        self.view.isUserInteractionEnabled = false
        Task {
            viewModel.callUploadChatMediaApi(media_type: "Audio", images: UIImage(), audio: data, video: URL(fileURLWithPath: ""), videoThum: UIImage())
            viewModel.successClosure = { [weak self] obj in
                if self?.audioFlag == true {
                    //                self?.indicator.stopAnimating()
                    self?.view.isUserInteractionEnabled = true
//                    SocketHelper.shared.sendMessage(data: [
//                        "sender_id": "\(loginMaster?.data?.user_id ?? 0)",
//                        "receiver_id": self?.reciverId,
//                        "message": "",
//                        "media_type": "Audio",
//                        "media": obj.data?.media ?? "",
//                        "user_type": self?.user ?? "",
//                        "ticketNo": self?.ticketNo ?? ""
//                    ])
                    self?.audioFlag = false
                    self?.back()
                }
            }
            viewModel.errorClosure = {
//                TUGHelpers.sharedInstance.showAlertWithTitle(messageBody: self.viewModel.errorString ?? "" , controller: AppObject.window?.rootViewController ?? UIViewController())
            }
        }
    }
}
