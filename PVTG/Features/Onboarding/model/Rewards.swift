/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct RewardsModel : Codable {
//	let created_at : String?
	let id : String?
	//let updated_at : String?
	let discount : String?
	let points : String?
	let milstone : String?

	enum CodingKeys: String, CodingKey {

		//case created_at = "created_at"
		case id = "id"
		//case updated_at = "updated_at"
		case discount = "discount"
		case points = "points"
		case milstone = "milstone"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
	//	created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		//updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		discount = try values.decodeIfPresent(String.self, forKey: .discount)
		points = try values.decodeIfPresent(String.self, forKey: .points)
		milstone = try values.decodeIfPresent(String.self, forKey: .milstone)
	}

}
