//
//  UploadMediaModel.swift
//  MarriageSaga
//
//  Created by Techugo on 21/11/22.
//

import Foundation
struct UploadMediaChatBaseModel : Codable {
    let status : Int?
    let message : String?
    let data : UploadMediaChat?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(UploadMediaChat.self, forKey: .data)
    }
    
}
struct UploadMediaChat : Codable {
    let media_type : String?
    let media : String?
    let videoThumbnail : String?
    
    enum CodingKeys: String, CodingKey {
        
        case media_type = "media_type"
        case media = "media"
        case videoThumbnail = "videoThumbnail"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        media_type = try values.decodeIfPresent(String.self, forKey: .media_type)
        media = try values.decodeIfPresent(String.self, forKey: .media)
        videoThumbnail = try values.decodeIfPresent(String.self, forKey: .videoThumbnail)
    }
    
}


