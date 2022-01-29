//
//  SporevoMapReducer.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/11.
//

import ReSwift
struct MapReducer {
    
    static func reducer(action: ReSwift.Action, state:MapState?)->MapState {
        var state = state ?? MapState()
        guard let action = action as? MapState.SporevoMapAction else { return state }
        switch action {
        case .fetchFacilities(facilities: let facilities):
            state.facilities = facilities
        }
        return state
    }
}
