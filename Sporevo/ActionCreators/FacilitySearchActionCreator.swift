//
//  FacilitySearchActionCreator.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/24.
//

import ReSwift
import Foundation
struct FacilitySearchActionCreator {
    
    static func deleteUserDefaults() {
        UserDefaultRepositry.shared.deleteFromUserDefaults(key: "tag")
        UserDefaultRepositry.shared.deleteFromUserDefaults(key: "sport")
        UserDefaultRepositry.shared.deleteFromUserDefaults(key: "facility")
        UserDefaultRepositry.shared.deleteFromUserDefaults(key: "city")
        UserDefaultRepositry.shared.deleteFromUserDefaults(key: "priceUnits")
    }
    
    static func loadUserDefaults() {
        let selectedTag:[Tag] = UserDefaultRepositry.shared.loadFromUserDefaults(key: "tag")
        let selectedFacility:[FacilityType] = UserDefaultRepositry.shared.loadFromUserDefaults(key: "facility")
        let selectedSports:[Sport] = UserDefaultRepositry.shared.loadFromUserDefaults(key: "sport")
        let selectedCity:[City] = UserDefaultRepositry.shared.loadFromUserDefaults(key: "city")
        let selectedPriceUnits:[PriceUnits] = UserDefaultRepositry.shared.loadFromUserDefaults(key: "priceUnits")
        
        appStore.dispatch(FacilitySearchState.FacilitySearchAction.setTag(tags: selectedTag))
        appStore.dispatch(FacilitySearchState.FacilitySearchAction.setSports(sports: selectedSports))
        appStore.dispatch(FacilitySearchState.FacilitySearchAction.setFacility(facility: selectedFacility))
        appStore.dispatch(FacilitySearchState.FacilitySearchAction.setPriceUnits(units: selectedPriceUnits))
        appStore.dispatch(FacilitySearchState.FacilitySearchAction.selectedCity(city: selectedCity))
    }
}
