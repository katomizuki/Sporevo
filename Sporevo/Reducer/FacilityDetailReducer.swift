//
//  FacilityDetailReducer.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/11.
//

import ReSwift

struct FacilityDetailReducer {
    
    static func reducer(action: ReSwift.Action, state:FacilityDetailState?)->FacilityDetailState {
        var state = state ?? FacilityDetailState()
        guard let action = action as? FacilityDetailState.FacilityDetailAction else { return state }
        switch action {
        case.fetchFacilityDetail(detail: let detail):
            state.facility = detail
        }
        return state
    }
}
