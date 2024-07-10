/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct AllTimeResult : Codable {
	let schedule_time_id : String?
	let from_time : String?
	let to_time : String?
	let total_ticket : String?
	let sold_ticket : String?
	let is_avilable_time : String?
    let session_booking_session_type : String?
    let session_booking_booking_date : String?
    let booked_price_type : String?

	enum CodingKeys: String, CodingKey {

		case schedule_time_id = "schedule_time_id"
		case from_time = "from_time"
		case to_time = "to_time"
		case total_ticket = "total_ticket"
		case sold_ticket = "sold_ticket"
		case is_avilable_time = "is_avilable_time"
        case session_booking_session_type = "session_booking_session_type"
        case session_booking_booking_date = "session_booking_booking_date"
        case booked_price_type = "session_booking_price_type"
        
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		schedule_time_id = try values.decodeIfPresent(String.self, forKey: .schedule_time_id)
		from_time = try values.decodeIfPresent(String.self, forKey: .from_time)
		to_time = try values.decodeIfPresent(String.self, forKey: .to_time)
		total_ticket = try values.decodeIfPresent(String.self, forKey: .total_ticket)
		sold_ticket = try values.decodeIfPresent(String.self, forKey: .sold_ticket)
		is_avilable_time = try values.decodeIfPresent(String.self, forKey: .is_avilable_time)
        session_booking_session_type = try values.decodeIfPresent(String.self, forKey: .session_booking_session_type)
        session_booking_booking_date = try values.decodeIfPresent(String.self, forKey: .session_booking_booking_date)
        booked_price_type = try values.decodeIfPresent(String.self, forKey: .booked_price_type)
	}

}
