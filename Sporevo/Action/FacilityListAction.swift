//
//  FacilityListAction.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/29.
//

import ReSwift
extension FacilityListState {
    
    enum FacilityListAction: ReSwift.Action {
        case getFacilityList(facilities: Facilities)
    }
}
