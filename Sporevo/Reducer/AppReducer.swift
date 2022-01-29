//
//  AppReducer.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/10.
//

import ReSwift

func appReduce(action:Action,state:AppState?)->AppState {
    var state = state ?? AppState()
    state.detailSearchState = DetailSearchReducer.reducer(action: action, state: state.detailSearchState)
    state.facilityDetailState = FacilityDetailReducer.reducer(action: action, state: state.facilityDetailState)
    return state
}
