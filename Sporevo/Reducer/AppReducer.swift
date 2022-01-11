//
//  AppReducer.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/10.
//

import ReSwift

func appReduce(action:Action,state:AppState?)->AppState {
    var state = state ?? AppState()
    state.detailState = DetailSearchReducer.reducer(action: action, state: state.detailState)
    state.facilityDetailState = FacilityDetailReducer.reducer(action: action, state: state.facilityDetailState)
    return state
}
