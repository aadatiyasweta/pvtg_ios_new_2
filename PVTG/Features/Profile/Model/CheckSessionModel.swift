//
//  CheckSessionModel.swift
//  PVTG
//
//  Created by Techugo on 28/06/24.
//  Copyright © 2024 ShubhamMacmini. All rights reserved.
//

import Foundation

struct CheckSessionModel : Codable {
    let statusCode : Int?
    let aPICODERESULT : String?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "statusCode"
        case aPICODERESULT = "APICODERESULT"
       
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        aPICODERESULT = try values.decodeIfPresent(String.self, forKey: .aPICODERESULT)
    }

}

