//
//  FacilityListReducer.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/31.
//

import ReSwift

struct FacilityListReducer {
    
    static func reducer(action: ReSwift.Action, state:FacilityListState?) -> FacilityListState {
        var state = state ?? FacilityListState()
        guard let action = action as? FacilityListState.FacilityListAction else { return state }
        switch action {
        case.getFacilityList(let list):
            state.facilities = list
        }
        return state
    }
}
