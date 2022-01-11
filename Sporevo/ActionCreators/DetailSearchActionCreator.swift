//
//  DetailSearchActionCreator.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/10.
//

import ReSwift
import RealmSwift
struct DetailSearchActionCreator {
    static func fetchPrefecture() {
        let realm = try! Realm()
        var citySections = [CitySection]()
        let prefectures = realm.objects(PrefectureEntity.self).sorted(byKeyPath: "id", ascending: true).map { Prefecture(name: $0.name, id: $0.id) }
        prefectures.forEach { pre in
            let cities:[City] = realm.objects(CityEntity.self).filter("prefectureId == \(pre.id)").map { City(id:$0.id,name:$0.name) }
            let section = CitySection(pre: pre, items: cities)
            citySections.append(section)
        }
        appStore.dispatch(DetailSearchState.DetailSearchAction.setPlaceSection(section: citySections))
    }
}
