//
//  SporevoMapAction.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/11.
//

import ReSwift
extension MapState {
    
    enum SporevoMapAction:ReSwift.Action {
        case fetchFacilities(facilities:[FacilityDetail])
    }
}
