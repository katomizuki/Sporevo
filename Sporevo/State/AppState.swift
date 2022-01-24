//
//  AppState.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/10.
//

import ReSwift
struct AppState: ReSwift.StateType {
    var detailState = DetailSearchState()
    var facilityDetailState = FacilityDetailState()
    var mapState = SporevoMapState()
    var facilitySearchState = FacilitySearchState()
}
