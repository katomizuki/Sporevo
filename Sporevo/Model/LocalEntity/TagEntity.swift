//
//  TagEntity.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/10.
//

import RealmSwift
class TagEntity: Object {
    @objc dynamic var id:Int = 0
    @objc dynamic var name:String = ""
}
