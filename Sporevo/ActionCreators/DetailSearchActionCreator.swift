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
    
    static func fetchTag() {
        let realm = try! Realm()
        let tags:[Tag] = realm.objects(TagEntity.self).map{ Tag(id: $0.id, name: $0.name) }
        appStore.dispatch(DetailSearchState.DetailSearchAction.setTags(tags:tags))
    }
    
    static func fetchSport() {
        let realm = try! Realm()
        let sports:[Sport] = realm.objects(SportEntity.self).map { Sport(name: $0.name, id: $0.id) }
        appStore.dispatch(DetailSearchState.DetailSearchAction.setSports(sports:sports))
    }
    
    static func fetchFacilityType() {
        let realm = try! Realm()
        let facilities:[FacilityType] = realm.objects(FacilityTypeEntity.self).map { FacilityType(id: $0.id, name: $0.name) }
        appStore.dispatch(DetailSearchState.DetailSearchAction.setFacilityType(types:facilities))
    }
    
    static func fetchMoneySections() {
        let realm = try! Realm()
        var moneySections = [MoneySection]()
        let moneyUnit:[MoneyUnits] = realm.objects(MoneyUnitsEntity.self).sorted(byKeyPath: "id", ascending: true).map { MoneyUnits(id: $0.id, name: $0.name) }
        moneyUnit.forEach { unit in
            let priceUnits:[PriceUnits] = realm.objects(PriceUnitsEntity.self).filter("moneyUnitId == \(unit.id)").map { PriceUnits(id:$0.id,name:$0.name) }
            let section = MoneySection(units: unit, prices: priceUnits)
            moneySections.append(section)
    }
        appStore.dispatch(DetailSearchState.DetailSearchAction.setMoneySections(sections: moneySections))
    }
    
    static func didSelectRowAt(option:SearchOptions,indexPath:IndexPath) {
        let id = indexPath.row
        let sectionId = indexPath.section
        switch option {
        case .place:
            if id == 0 { return }
            appStore.dispatch(DetailSearchState.DetailSearchAction.cityTap(id: id, sectionId: sectionId))
        case .institution:
            appStore.dispatch(DetailSearchState.DetailSearchAction.institutionTap(id: id))
        case .competition:
            appStore.dispatch(DetailSearchState.DetailSearchAction.sportTap(id: id))
        case .price:
            if id == 0 { return }
            appStore.dispatch(DetailSearchState.DetailSearchAction.moneyTap(id: id, sectionId: sectionId))
        case .tag:
            appStore.dispatch(DetailSearchState.DetailSearchAction.tagTap(id: id))
        }
    }
    
    static func saveUserDefaults(option:SearchOptions) {
        appStore.dispatch(DetailSearchState.DetailSearchAction.saveUserDefaults(option: option))
    }
    
    static func didTapSection(section: Int,option:SearchOptions) {
        if option == .place {
            appStore.dispatch(DetailSearchState.DetailSearchAction.tapSectionPlace(section: section))
            
        } else {
            appStore.dispatch(DetailSearchState.DetailSearchAction.tapSectionMoney(section:section))
        }
    }
   
}

