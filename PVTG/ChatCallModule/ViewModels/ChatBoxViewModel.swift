//
//  ChatBoxViewModel.swift
//  reachout
//
//  Created by Anuj Techugo on 19/08/21.
//  Copyright © 2021 techugo. All rights reserved.
//

import Foundation
import UIKit

extension ChatBoxViewModel {
    func viewDidLoad(reciverId: String,user: String,ticketNo: String,otherUser:String) {
        //self.setupKeyboardObserver()
        
        guard let view = self.view else { return }
        view.titleLbl.text = self.partnerName
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            //            SocketHelper.shared.initChat(s_id: loginMaster?.data?.user_id ?? 0, r_id: reciverId, user: user, otherUser: otherUser)
            //            SocketHelper.shared.getChatList(s_id: loginMaster?.data?.user_id ?? 0, r_id: Int(reciverId) ?? 0, ticketNo: ticketNo) { messages in
            //                        view.adapter.set(messages)
            //                    }
            //            SocketHelper.shared.receiveMessage { message in
            //                view.adapter.appendNew(message)
            //            }
        }
        
    }
    
    func viewWillAppear() {
        //self.setupObservers()
    }
    
    func viewDidAppear() {
        
    }
    
    func viewWillDisappear() {
        self.removeObservers()
    }
    
    func viewDidDisappear() {
        
    }
}

class ChatBoxViewModel {
    weak var view: ChatBoxView?
    var partnerID: Int!
    var partnerName: String! = "Audio Chat"
    var partnerImage: String?
    var successClosure :((FileUploadRespModel) -> Void)?
    var errorClosure:() -> (Void) = {   }
    var errorString:String?
    var errorDeleteClosure:() -> (Void) = {   }
    var errorDeleteString:String?
    var succesDeleteClosure:() -> (Void) = {   }
    
    private weak var playAudioObserver: NSObjectProtocol?
    private weak var socketStatusObserver: NSObjectProtocol?
}

//MARK: - Observer Methods
extension ChatBoxViewModel {
    
    private func setupKeyboardObserver() {
        guard let view = self.view else { return }
        view.setKeyboard { [weak self] (height) in
            guard let view = self?.view else {return}
            view.messageTVBottom.constant = height
            view.view.layoutIfNeeded()
        }
    }
    
    private func setupObservers() {
        guard let view = self.view else {return}
        self.playAudioObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name("play_audio"), object: nil, queue: .main, using: { noti in
            guard let message = noti.object as? MessageModel else {return}
            view.navigate(toView: RecordAudioPopupView.self, style: .present)
            //            {vc in
            //                vc.message = message
            //            }
        })
        //
        //        view.adapter.setImagePreviewHandler { msg in
        //            view.navigate(toView: ImagePreviewView.self) {vw in
        //                vw.set(list: msg.url)
        //            }
        //        }
        
    }
    
    private func removeObservers() {
        [
            self.playAudioObserver,
            self.socketStatusObserver,
        ].compactMap({$0}).forEach({NotificationCenter.default.removeObserver($0)})
        
    }
    func callUploadChatMediaApi(media_type:String,images:UIImage,audio:Data,video: URL,videoThum:UIImage)
    {
//        let requestDict = ["media_type":media_type]
//        let rqst = Services.requestToUploadChatMedia(dict: requestDict, profilePic: images, videoThumbnail: videoThum, videoProfile: video, type: media_type, audio: audio)
//        ServiceMaster.sharedInstance.callDataUploadServiceWithRequest(for: FileUploadRespModel.self, rqst: rqst, withResponse: { [weak self] (response) in
//            let objMaster = response?.objDecodable as! FileUploadRespModel
//            if objMaster.statusCode == 200{
//                self?.successClosure?(objMaster)
//            }else{
//                guard let message = objMaster.statusMessage else {
//                    return
//                }
//                self!.errorString = message
//                self!.errorClosure()
//            }
//
//        }) { (error) in
//
//        }
    }
    
    
    func callDeleteChatAPI(chat_id:String)
    {
        let requestDict1: [String: String] = [
            "chat_id": chat_id
        ]
        
//        let rqst = Services.requestToDeletChat(dict: requestDict1)
//        ServiceMaster.sharedInstance.getResponseInModelData(for: UserObjectMaster.self, rqst: rqst, withResponse: { [weak self] (response) in
//            let objMaster = response?.objDecodable as! UserObjectMaster
//            if objMaster.status == 200 {
//                self?.succesDeleteClosure()
//            }else{
//                guard let message = objMaster.message else {
//                    return
//                }
//                self!.errorDeleteString = message
//                self!.errorDeleteClosure()
//            }
//        }) { (error) in
//
//        }
    }
}

