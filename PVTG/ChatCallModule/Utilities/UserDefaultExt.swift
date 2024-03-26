//
//  UserDefaultExt.swift
//  SocketAudioChat
//
//  Created by Anuj Kumar on 07/11/22.
//

import Foundation

extension UserDefaults {
    
    static var user_id: Int! {
        get {
            UserDefaults.standard.value(forKey: "user_id") as! Int
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "user_id")
            UserDefaults.standard.synchronize()
        }
    }
}
