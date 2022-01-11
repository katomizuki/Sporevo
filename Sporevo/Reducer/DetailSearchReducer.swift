//
//  DetailSearchReducer.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/10.
//

import ReSwift
struct DetailSearchReducer {
    static func reducer(action: ReSwift.Action, state:DetailSearchState?)->DetailSearchState {
        var state = state ?? DetailSearchState()
        guard let action = action as? DetailSearchState.DetailSearchAction else { return state }
        switch action {
        case .setPlaceSection(section: let sections):
            state.placeSections = sections
        case .setTags(tags: let tags):
            state.tags = tags
        case .setSports(sports: let sports):
            state.sports = sports
        case .setFacilityType(types: let types):
            state.facilityType = types
        case .setMoneySections(sections: let sections):
            state.moneySections = sections
        }
        return state
    }
}
