//
//  ChatBoxModels.swift
//  reachout
//
//  Created by Anuj Techugo on 20/08/21.
//  Copyright © 2021 techugo. All rights reserved.
//

import Foundation

enum ChatBotTVAdapterCellCase {
    case MyMessageTVCell(msg: MessageModel)
    case PartnerMessageTVCell(msg: MessageModel)
    case MyAudioTVCell(msg: MessageModel)
    case PartnerAudioTVCell(msg: MessageModel)
    case MyImageTVCell(msg: MessageModel)
    case PartnerImageTVCell(msg: MessageModel)
    case MyImagesTVCell(msg: MessageModel)
    case PartnerImagesTVCell(msg: MessageModel)
    case MyVideoTVCell(msg: MessageModel)
    case PartnerVideoTVCell(msg: MessageModel)
    
}

struct MessageHistoryModel: Codable {
    var msg: String
    var date_added: String
    var name: String
    var r_id: Int
    var s_id: Int
    var profile_picture: String?
    var online_status: String
}

struct ChatListRespModel: Codable {
    let result: [MessageModel]
}
struct GetChatHistory : Codable{
    let added_on : String?
    let id : Int?
    let msg : String?
    let msg_type : MessageType
    let r_id : String?
    let read_status : String?
    let receiver_name : String?
    let s_id : String?
    let service_name : String?
    let thumbnail : String?
    let type : String?
    let url : String?
    let profile_image : String?
    let unread_cn : Int?
    let isDeleted : String?
    let status : String?
}

struct MessageModel: Codable {
    let id : Int?
    let sID, rID: Int
    let msg: String
    let url: String
    let msgType: MessageType
    let addedOn: String
    let read_status : String?
    let videoThumbnail : String?
    let lat, long : Double?
    
    enum CodingKeys: String, CodingKey {
        case id = "chat_id"
        case sID = "s_id"
        case rID = "r_id"
        case msg = "msg"
        case url = "url"
        case msgType = "msg_type"
        case addedOn = "date_added"
        case read_status = "read_status"
        case videoThumbnail = "thumb_url"
        case lat = "lat"
        case long = "long"
    }
}

enum MessageType: String, Codable {
    case text, image, Audio,video,location
}

struct FileUploadRespModel: Codable{
    var statusCode: Int?
    var statusMessage: String?
    var data: [String]?
}
