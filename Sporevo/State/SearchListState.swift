//
//  FacilitySearchState.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/24.
//

import ReSwift

struct SearchListState:StateType {
    var selectedTag = [Tag]()
    var selectedSports = [Sport]()
    var selectedFacility = [FacilityType]()
    var selectedPriceUnits = [PriceUnits]()
    var selectedCity = [City]()
}
