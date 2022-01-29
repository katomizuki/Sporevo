//
//  FacilitySearchReducer.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/24.
//

import ReSwift
struct SearchListReducer {
    
    static func reducer(action: ReSwift.Action, state:SearchListState?)->SearchListState {
        var state = state ?? SearchListState()
        guard let action = action as? SearchListState.FacilitySearchAction else { return state }
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
