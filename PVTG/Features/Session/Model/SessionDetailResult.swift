/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct SessionDetailResult : Codable {
	let session_id : String?
	let name_of_listing : String?
	let description : String?
	let ticket_price : String?
	let address_id : String?
	let address : String?
	let city : String?
	let latitude : String?
	let longitude : String?
	let category_name : String?
	let distance : String?
	let rating : String?
	let bio : String?
    let vendorName : String?
	let images : [Images]?
	let all_date : [All_date]?
    let currency : String?
    let session_type : [SessionTypeModel]?
    let session_language : String?
    let booking_session_type : String?
    let booking_date : String?
    let payment_id : String?
    let paid_amount : String?

	enum CodingKeys: String, CodingKey {

		case session_id = "session_id"
		case name_of_listing = "name_of_listing"
		case description = "description"
		case ticket_price = "ticket_price"
		case address_id = "address_id"
		case address = "address"
		case city = "city"
		case latitude = "latitude"
		case longitude = "longitude"
		case category_name = "category_name"
		case distance = "distance"
		case rating = "rating"
		case bio = "bio"
		case images = "images"
		case all_date = "all_date"
        case currency = "currency"
        case vendorName = "name"
        case session_type = "session_type"
        case session_language = "session_language"
        case booking_session_type = "booking_session_type"
        case booking_date = "booking_date"
        case payment_id = "payment_id"
        case paid_amount = "paid_amount"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		session_id = try values.decodeIfPresent(String.self, forKey: .session_id)
		name_of_listing = try values.decodeIfPresent(String.self, forKey: .name_of_listing)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		ticket_price = try values.decodeIfPresent(String.self, forKey: .ticket_price)
		address_id = try values.decodeIfPresent(String.self, forKey: .address_id)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		city = try values.decodeIfPresent(String.self, forKey: .city)
		latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
		longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
		category_name = try values.decodeIfPresent(String.self, forKey: .category_name)
		distance = try values.decodeIfPresent(String.self, forKey: .distance)
		rating = try values.decodeIfPresent(String.self, forKey: .rating)
		bio = try values.decodeIfPresent(String.self, forKey: .bio)
		images = try values.decodeIfPresent([Images].self, forKey: .images)
		all_date = try values.decodeIfPresent([All_date].self, forKey: .all_date)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
         vendorName = try values.decodeIfPresent(String.self, forKey: .vendorName)
        booking_session_type = try values.decodeIfPresent(String.self, forKey: .booking_session_type)
        session_language = try values.decodeIfPresent(String.self, forKey: .session_language)
        session_type = try values.decodeIfPresent([SessionTypeModel].self, forKey: .session_type)
        booking_date = try values.decodeIfPresent(String.self, forKey: .booking_date)
        payment_id = try values.decodeIfPresent(String.self, forKey: .payment_id)
        paid_amount = try values.decodeIfPresent(String.self, forKey: .paid_amount)
	}

}
struct SessionTypeModel : Codable {
    let session_type : String?
    let session_type_id : String?
    let price : String?
    enum CodingKeys: String, CodingKey {

        case session_type = "session_type"
        case session_type_id = "session_type_id"
        case price = "price"
        
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        session_type = try values.decodeIfPresent(String.self, forKey: .session_type)
        session_type_id = try values.decodeIfPresent(String.self, forKey: .session_type_id)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        
    }
}
