//
//  FacilitySearchAction.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/24.
//

import ReSwift
extension FacilitySearchState {
    enum FacilitySearchAction: ReSwift.Action {
        case setTag(tags:[Tag])
        case setSports(sports: [Sport])
        case setFacility(facility: [FacilityType])
        case setPriceUnits(units:[PriceUnits])
        case selectedCity(city:[City])
    }
}
