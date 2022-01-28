//
//  FacilityDetail.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/28.
//

struct FacilityDetail:Codable {
    var access:String?
    var address:String?
    var facility_type:String?
    var group_use_regist:String?
    var group_use_regist_text:String?
    var lat:Double?
    var lng:Double?
    var name:String?
    var booking_url:String?
    var business_hours:String?
    var holiday:String?
    var how_to_book:String?
    var hp:String?
    var informer:String?
    var memo:String?
    var phone_number:String?
    var price_info:String?
    var personal_use_regist:String?
    var personal_use_regist_text:String?
    var sub_name:String?
    var booking_types:[String]
    var equipment_types:[String]
    var parking_types:[String]
    var price_ranges:[String]
    var sports_types:[String]
    var tags:[String]
    var updated_at:String?
    var user_types:[String]
}
