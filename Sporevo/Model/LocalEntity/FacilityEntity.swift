//
//  FacilityEntity.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/10.
//

import RealmSwift
class FacilityEntity:Object {
    @objc dynamic var name:String = ""
    @objc dynamic var id:Int = 0
    @objc dynamic var address:String = ""
    @objc dynamic var subName:String = ""
    let tags = List<TagTitle>()
    let sportsType = List<SportsType>()
}
class TagTitle:Object {
    @objc dynamic var title:String = ""
}
class SportsType:Object {
    @objc dynamic var name: String = ""
}
