//
//  URLs.swift
//  SocketAudioChat
//
//  Created by Anuj Kumar on 05/11/22.
//

import Foundation
extension URL {
    public static let BASE_ROOT = "http://13.126.131.184:7198"
    
    public static let ServerSocketHost = URL(string: BASE_ROOT)!
    public static let fileUpload = URL(string: "http://13.126.131.184:3000/api/v1/user/uploadChatMedia")!
}
