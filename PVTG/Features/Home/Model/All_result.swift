/* 
 Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar
 
 */

import Foundation
struct All_result : Codable {
    let session_id : String?
    let name_of_listing : String?
    let session_image : String?
    let created_by : String?
    let city : String?
    let category_name : String?
    let rating : String?
    let distance : String?
    let address : String?
    let address_id : String?
    
    enum CodingKeys: String, CodingKey {
        case session_id = "session_id"
        case name_of_listing = "name_of_listing"
        case session_image = "session_image"
        case created_by = "created_by"
        case city = "city"
        case category_name = "category_name"
        case rating = "rating"
        case distance = "distance"
        case address = "address"
        case address_id = "address_id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        session_id = try values.decodeIfPresent(String.self, forKey: .session_id)
        name_of_listing = try values.decodeIfPresent(String.self, forKey: .name_of_listing)
        session_image = try values.decodeIfPresent(String.self, forKey: .session_image)
        created_by = try values.decodeIfPresent(String.self, forKey: .created_by)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        category_name = try values.decodeIfPresent(String.self, forKey: .category_name)
        rating = try values.decodeIfPresent(String.self, forKey: .rating)
        distance = try values.decodeIfPresent(String.self, forKey: .distance)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        address_id = try values.decodeIfPresent(String.self, forKey: .address_id)
    }
}
