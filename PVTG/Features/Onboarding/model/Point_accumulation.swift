/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Point_accumulationModel : Codable {
	let view_token_notification : String?
	let first_booking_point : String?
	let id : String?
	//let created_at : String?
	let review_rate : String?
	let vendor_cancel_booking_points : String?
	//let updated_at : String?
	let bookings : String?
	let first_login_point : String?

	enum CodingKeys: String, CodingKey {

		case view_token_notification = "view_token_notification"
		case first_booking_point = "first_booking_point"
		case id = "id"
	//	case created_at = "created_at"
		case review_rate = "review_rate"
		case vendor_cancel_booking_points = "vendor_cancel_booking_points"
	//	case updated_at = "updated_at"
		case bookings = "bookings"
		case first_login_point = "first_login_point"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		view_token_notification = try values.decodeIfPresent(String.self, forKey: .view_token_notification)
		first_booking_point = try values.decodeIfPresent(String.self, forKey: .first_booking_point)
		id = try values.decodeIfPresent(String.self, forKey: .id)
	//	created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		review_rate = try values.decodeIfPresent(String.self, forKey: .review_rate)
		vendor_cancel_booking_points = try values.decodeIfPresent(String.self, forKey: .vendor_cancel_booking_points)
	//	updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		bookings = try values.decodeIfPresent(String.self, forKey: .bookings)
		first_login_point = try values.decodeIfPresent(String.self, forKey: .first_login_point)
	}

}
