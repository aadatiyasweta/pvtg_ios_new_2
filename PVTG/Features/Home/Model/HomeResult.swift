/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct HomeResult : Codable {
	let all_result : [All_result]?
	let all_category : [All_category]?
    let user_image : String?
    let min_price : Int?
    let max_price : Int?
    let min_val : Int?
    let max_val : Int?
    let currency_data : [String]?
    let selected_currency : String?
    
	enum CodingKeys: String, CodingKey {

		case all_result = "all_result"
		case all_category = "all_category"
        case user_image = "user_image"
        case min_price = "min_price"
        case max_price = "max_price"
        case min_val = "min_val"
        case max_val = "max_val"
        case currency_data = "currency_data"
        case selected_currency = "selected_currency"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		all_result = try values.decodeIfPresent([All_result].self, forKey: .all_result)
		all_category = try values.decodeIfPresent([All_category].self, forKey: .all_category)
        user_image = try values.decodeIfPresent(String.self, forKey: .user_image)
        min_price = try values.decodeIfPresent(Int.self, forKey: .min_price)
        max_price = try values.decodeIfPresent(Int.self, forKey: .max_price)
        min_val = try values.decodeIfPresent(Int.self, forKey: .min_val)
        max_val = try values.decodeIfPresent(Int.self, forKey: .max_val)
        currency_data = try values.decodeIfPresent([String].self, forKey: .currency_data)
        selected_currency = try values.decodeIfPresent(String.self, forKey: .selected_currency)
	}

}

