//
//  FacilitySearchReducer.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/24.
//

import ReSwift
struct FacilitySearchReducer {
    
    static func reducer(action: ReSwift.Action, state:FacilitySearchState?)->FacilitySearchState {
        var state = state ?? FacilitySearchState()
        guard let action = action as? FacilitySearchState.FacilitySearchAction else { return state }
        switch action {
        case .selectedCity(let cities):
            state.selectedCity = cities
        case .setPriceUnits(let units):
            state.selectedPriceUnits = units
        case .setSports(let sports):
            state.selectedSports = sports
        case .setTag(let tags):
            state.selectedTag = tags
        case .setFacility(let facilities):
            state.selectedFacility = facilities
        }
        return state
    }
}
