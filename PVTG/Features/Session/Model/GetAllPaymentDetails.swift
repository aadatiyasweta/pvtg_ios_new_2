//
//  GetAllPaymentDetails.swift
//  PVTG
//
//  Created by kashish on 10/02/22.
//  Copyright © 2022 ShubhamMacmini. All rights reserved.
//

import UIKit
import Foundation

struct GetAllPaymentDetails : Codable {
 let statusCode : Int?
 let aPICODERESULT : String?
 let result : [GetAllPaymentDetailsData]?

 enum CodingKeys: String, CodingKey {

  case statusCode = "statusCode"
  case aPICODERESULT = "APICODERESULT"
  case result = "result"
 }

 init(from decoder: Decoder) throws {
  let values = try decoder.container(keyedBy: CodingKeys.self)
  statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
  aPICODERESULT = try values.decodeIfPresent(String.self, forKey: .aPICODERESULT)
  result = try values.decodeIfPresent([GetAllPaymentDetailsData].self, forKey: .result)
 }

}

struct GetAllPaymentDetailsData : Codable {
 let session_id : String?
 let charge_id : String?

 enum CodingKeys: String, CodingKey {

  case session_id = "session_id"
  case charge_id = "charge_id"
 }

 init(from decoder: Decoder) throws {
  let values = try decoder.container(keyedBy: CodingKeys.self)
  session_id = try values.decodeIfPresent(String.self, forKey: .session_id)
  charge_id = try values.decodeIfPresent(String.self, forKey: .charge_id)
 }

}
