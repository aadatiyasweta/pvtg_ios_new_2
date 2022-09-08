/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct User_profile : Codable {
	let name : String?
	let email : String?
	let country_code : String?
	let phone : String?
	let user_image : String?
	let acc_type : String?
	let selected_category : String?
	let total_point : String?

	enum CodingKeys: String, CodingKey {
		case name = "name"
		case email = "email"
		case country_code = "country_code"
		case phone = "phone"
		case user_image = "user_image"
		case acc_type = "acc_type"
		case selected_category = "selected_category"
		case total_point = "total_point"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		country_code = try values.decodeIfPresent(String.self, forKey: .country_code)
		phone = try values.decodeIfPresent(String.self, forKey: .phone)
		user_image = try values.decodeIfPresent(String.self, forKey: .user_image)
		acc_type = try values.decodeIfPresent(String.self, forKey: .acc_type)
		selected_category = try values.decodeIfPresent(String.self, forKey: .selected_category)
		total_point = try values.decodeIfPresent(String.self, forKey: .total_point)
	}

}
