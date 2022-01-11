//
//  FacilityDetailAction.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/11.
//

import ReSwift
extension FacilityDetailState {
    enum FacilityDetailAction:ReSwift.Action {
        case fetchFacilityDetail(detail: FacilityDetail)
    }
}
