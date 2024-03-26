//
//  Config.swift
//  PVTG
//
//  Created by Techugo on 21/03/24.
//  Copyright © 2024 ShubhamMacmini. All rights reserved.
//

import Foundation

class Config {
    static var shared = Config()
    
    private init() {}
    
    func baseUrl()-> String {
        guard let baseUrl = Bundle.main.infoDictionary?["kBaseUrl"] as? String, !baseUrl.isEmpty else{fatalError("BaseUrl is not set in xcconfig file")}
        print("baseUrl",baseUrl)
        return baseUrl
    }
    
    func socketUrl()-> String {
        guard let socketUrl = Bundle.main.infoDictionary?["kSocketUrl"] as? String, !socketUrl.isEmpty else{fatalError("socketUrl is not set in xcconfig file")}
        return socketUrl
    }
    
}
