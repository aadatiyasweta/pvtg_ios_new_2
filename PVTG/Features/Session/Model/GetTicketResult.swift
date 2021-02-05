/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct GetTicketResult : Codable {
	let ticket_avilable : String?
	let ticket_price : String?
	let total_point : String?
    let user_booking : Int?
	enum CodingKeys: String, CodingKey {

		case ticket_avilable = "ticket_avilable"
		case ticket_price = "ticket_price"
		case total_point = "total_point"
        case user_booking = "user_booking"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		ticket_avilable = try values.decodeIfPresent(String.self, forKey: .ticket_avilable)
		ticket_price = try values.decodeIfPresent(String.self, forKey: .ticket_price)
		total_point = try values.decodeIfPresent(String.self, forKey: .total_point)
        user_booking = try values.decodeIfPresent(Int.self, forKey: .user_booking)
	}

}
struct CustomBokingModel {
    var user_id: String?
    var session_id: String?
    var latitude: String
    var longitude: String?
    var booking_date: String?
    var booking_from_time: String?
    var booking_to_time: String?
    var paid_amount: String?
    var schedule_time_id: String?
    init(user_id: String, session_id: String, latitude: String, longitude: String, booking_date: String, booking_from_time: String, booking_to_time: String, paid_amount: String, schedule_time_id: String) {
        self.user_id = user_id
        self.session_id = session_id
        self.latitude = latitude
        self.longitude = longitude
        self.booking_date = booking_date
        self.booking_from_time = booking_from_time
        self.booking_to_time = booking_to_time
        self.paid_amount = paid_amount
        self.schedule_time_id = schedule_time_id
        
    }
}
