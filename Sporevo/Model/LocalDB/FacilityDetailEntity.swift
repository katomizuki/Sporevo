//
//  FacilityDetailEntity.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/10.
//

import RealmSwift
class FacilityDetailEntity:Object {
    @objc dynamic var access:String = ""
    @objc dynamic var address:String  = ""
    @objc dynamic var facilityType:String  = ""
    @objc dynamic var groupUseRegist:String  = ""
    @objc dynamic var lat:Double = 0.0
    @objc dynamic var lng:Double = 0.0
    @objc dynamic var name:String  = ""
    @objc dynamic var bookingUrl:String  = ""
    @objc dynamic var businessHours:String  = ""
    @objc dynamic var howToBook:String  = ""
    @objc dynamic var hp:String  = ""
    @objc dynamic var informer:String  = ""
    @objc dynamic var memo:String  = ""
    @objc dynamic var holiday:String  = ""
    @objc dynamic var phoneNumber:String = ""
    @objc dynamic var priceInfo:String = ""
    @objc dynamic var personalUseRegist:String = ""
    @objc dynamic var personalUseRegistText:String = ""
    @objc dynamic var subName:String = ""
    @objc dynamic var bookingType:[String] = [String]()
    @objc dynamic var equipmentTypes:[String] = [String]()
    @objc dynamic var parkingTypes:[String] = [String]()
    @objc dynamic var priceRanges:[String] = [String]()
    @objc dynamic var sportsType:[String] = [String]()
    @objc dynamic var tags:[String] = [String]()
    @objc dynamic var updateAt:String = ""
    @objc dynamic var userTypes:[String] = [String]()
}
