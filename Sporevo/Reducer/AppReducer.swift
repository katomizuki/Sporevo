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
    state.instituationListState = FacilityListReducer.reducer(action: action, state: state.instituationListState)
    state.mainState = MainReducer.reducer(action: action, state: state.mainState)
    state.mapState = MapReducer.reducer(action: action, state: state.mapState)
    state.searchListState = SearchListReducer.reducer(action: action, state: state.searchListState)
    return state
}
