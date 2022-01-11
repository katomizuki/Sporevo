//
//  DetailSearchAction.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/10.
//

import ReSwift
extension DetailSearchState {
    enum DetailSearchAction: ReSwift.Action {
        case setPlaceSection(section: [CitySection])
        case setTags(tags:[Tag])
        case setSports(sports:[Sport])
        case setFacilityType(types:[FacilityType])
        case setMoneySections(sections:[MoneySection])
    }
}
