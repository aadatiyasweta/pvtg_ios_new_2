//
//  SocketHelper.swift
//  reachout
//
//  Created by Anuj Techugo on 19/08/21.
//  Copyright © 2021 techugo. All rights reserved.
//

import SocketIO
import Network

enum SocketEvent: String {
    case addUser
    case getChatMessages
    case sendUserMessage
    case receiveMessage
    case disconnectChat
    case getChatHistory
}

class SocketHelper: NSObject {
    
    static let shared = SocketHelper()
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    var getChatListClosure :(([MessageModel]?) -> Void)?
    var sendMessageClosure :((MessageModel?) -> Void)?
    var getChatHistoryClosure :(([GetChatHistory]?) -> Void)?
    var callBackConnect:(()->())?
    var callBackConnectSendMessage:(()->())?
    var callBackConnectDisconnect:(()->())?
    var callBackDisConnected:(()->())?
    var callBackConnectList:(()->())?
    
    private var eventUUIDs: [UUID] = []
    var isConnected = false
    var type = ""
    
    override init() {
        super.init()
    }
    
    //MARK: - Common to both
    private func configureSocketClient() {
//        var chaturl =  "\(scheme)://\(baseUrl):\(chatPort)"
//        if chatPort == "nil" {
//            chaturl = "\(scheme)://\(baseUrl)"
//        }
        
        self.manager = SocketManager(socketURL: URL(string: Config.shared.socketUrl()) ?? .ServerSocketHost, config: [.log(true),.version(.two)])
        guard let manager = self.manager else {return}
        self.socket = SocketIOClient(manager: manager, nsp: "audio_chat")
        socket = manager.defaultSocket
        
        socket!.on(clientEvent: .connect, callback: { data, ack in
            
            self.isConnected = true
            if self.type == "send"{
                self.callBackConnectSendMessage?()
            }
            else if self.type == "disconnet"{
                self.callBackDisConnected?()
            }
            else if self.type == "list"{
                self.callBackConnectList?()
            }
            else {
                self.callBackConnect?()
            }
            self.type = ""
        })
        
        socket!.on(clientEvent: .disconnect, callback: { data, ack in
           
            self.isConnected = false
            self.callBackDisConnected?()
        })
        socket!.on(SocketEvent.sendUserMessage.rawValue) { [weak self] results, _ in
           
            guard results.count > 0,
                  let dict = results[0] as? [String: Any],
               //   let result = dict["result"] as? [String: Any],
                  let final = self?.jsonData(from: dict)
            else {return}
            do {
                let messages = try JSONDecoder().decode(MessageModel.self, from: final)
                self?.sendMessageClosure?(messages)
            } catch {
                
                PVTG.showAlert(strTitle: error.localizedDescription)
            }
        }
        
        socket!.on(SocketEvent.receiveMessage.rawValue) { [weak self] results, _ in
           
            guard results.count > 0,
                  let dict = results[0] as? [String: Any],
                  let result = dict["result"] as? [String: Any],
                  let final = self?.jsonData(from: result)
            else {return}
            do {
                let messages = try JSONDecoder().decode(MessageModel.self, from: final)
                self?.sendMessageClosure?(messages)
            } catch {
                
                PVTG.showAlert(strTitle: error.localizedDescription)
            }
        }
        
        socket!.on(SocketEvent.getChatMessages.rawValue) { [weak self] results, _ in
        //    AppObject.stopLoader()
            guard results.count > 0,
                  let dict = results.first as? [String: Any],
                //  let result = dict["result"] as? [String: Any],
                  let datas = dict["chat"] as? [Any],
                  let final = self?.jsonData(from: datas)
            else {return}
            do {
                let messages = try JSONDecoder().decode([MessageModel].self, from: final)
                self?.getChatListClosure?(messages)
            } catch {
                PVTG.showAlert(strTitle: error.localizedDescription)
            }
        }
        socket!.on(SocketEvent.getChatHistory.rawValue) { [weak self] results, _ in
           // AppObject.stopLoader()
            guard results.count > 0,
                  let dict = results.first as? [String: Any],
                  let result = dict["result"] as? [String: Any],
                  let datas = result["rows"] as? [Any],
                  let final = self?.jsonData(from: datas)
            else {return}
            do {
                let messages = try JSONDecoder().decode([GetChatHistory].self, from: final)
                self?.getChatHistoryClosure?(messages)
            } catch {
                PVTG.showAlert(strTitle: error.localizedDescription)
            }
        }
        
    }
    
    
    func off(event: SocketEvent) {
        guard let socket = manager?.defaultSocket else {return}
        socket.off(event.rawValue)
    }
    
    func establishConnection(type:String) {
        self.configureSocketClient()
        guard let socket = manager?.defaultSocket else {return}
        self.eventUUIDs.forEach({socket.off(id: $0)})
        self.eventUUIDs = []
        self.type = type
        socket.connect()
        
//        self.isConnected = true
    }
    
    func disconnect(senderId : String) {
        guard let socket = manager?.defaultSocket else {return}
        self.eventUUIDs.forEach({socket.off(id: $0)})
        self.eventUUIDs = []
        socket.emit(SocketEvent.disconnectChat.rawValue, [
            "s_id": senderId
        ])
        socket.disconnect()
        self.isConnected = false
    }
    func disconnect() {
        guard let socket = manager?.defaultSocket else {return}
        self.eventUUIDs.forEach({socket.off(id: $0)})
        self.eventUUIDs = []
        socket.disconnect()
        self.isConnected = false
    }
    
    func initChat(s_id: String,r_id: String,user: String,otherUser: String) {
        guard let socket = manager?.defaultSocket else {return}
        socket.emit(SocketEvent.addUser.rawValue, [
            "user_id": "\(s_id)",
            "user_type":user,
            "other_user_id":r_id,
            "other_user_type":otherUser
        ])
    }
    
    func getChatList(s_id: String, r_id: String,ticketNo: String,offset : Int) {
        guard let socket = manager?.defaultSocket else {return}
      
        socket.emit(SocketEvent.getChatMessages.rawValue, [
            "user_id": "\(s_id)",
            "other_user_id": "\(r_id)"
//            "ticketNo": ticketNo,
//            "page" : offset,
//            "limit" : 10
        ] as [String : Any])
    }
    
    func getChatHistoryList(s_id: String,offset : Int) {
        guard let socket = manager?.defaultSocket else {return}
      
        socket.emit(SocketEvent.getChatHistory.rawValue, [
            "s_id": "\(s_id)",
            "page" : offset,
            "limit" : 10
        ] as [String : Any])
    }
    
    func sendMessage(data: [String: Any]) {
        guard let socket = manager?.defaultSocket else {return}
        socket.emit(SocketEvent.sendUserMessage.rawValue, data)
    }
    
    func receiveMessage() {
        guard let socket = manager?.defaultSocket else {return}
        let uuid = socket.on(SocketEvent.sendUserMessage.rawValue) { [weak self] results, _ in
          
            guard results.count > 0,
                  let dict = results[0] as? [String: Any],
                  let final = self?.jsonData(from: dict)
            else {return}
            do {
                let messages = try JSONDecoder().decode(MessageModel.self, from: final)
                self?.sendMessageClosure?(messages)
            } catch {
                PVTG.showAlert(strTitle: error.localizedDescription)
            }
        }
        
    }
    func decodeObject<Y: Decodable>(_ object:Any,decoder: JSONDecoder = .init(), completion: @escaping (Y ) -> ()) {
        do {
            let data = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
            let model = try decoder.decode(Y.self, from: data)
            completion(model)
        } catch let jsonErr {
            print("failed to decode, \(jsonErr)")
        }
    }
    func jsonData<T>(from object: T) -> Data? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {return nil}
        return data
    }
}
