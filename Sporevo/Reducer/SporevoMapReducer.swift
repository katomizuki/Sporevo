//
//  SporevoMapReducer.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/11.
//

import ReSwift
struct SporevoMapReducer {
    
    static func reducer(action: ReSwift.Action, state:SporevoMapState?)->SporevoMapState {
        var state = state ?? SporevoMapState()
        guard let action = action as? SporevoMapState.SporevoMapAction else { return state }
        switch action {
        case .fetchFacilities(facilities: let facilities):
            state.facilities = facilities
        }
        return state
    }
}
