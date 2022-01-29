//
//  AppState.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/10.
//

import ReSwift
struct AppState: ReSwift.StateType {
    var detailSearchState = DetailSearchState()
    var facilityDetailState = FacilityDetailState()
    var mapState = MapState()
    var mainState = MainState()
    var searchListState = SearchListState()
    var instituationListState = FacilityListState()
}
