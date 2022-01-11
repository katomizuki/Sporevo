//
//  DetailSearchState.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/10.
//

import ReSwift
struct DetailSearchState: StateType {
    var placeSections = [CitySection]()
    var tags = [Tag]()
    var sports = [Sport]()
    var facilityType = [FacilityType]()
    var moneySections = [MoneySection]()
    var selectedCity = [City]()
    var selectedTag = [Tag]()
    var selectedInstion = [FacilityType]()
    var selectedCompetion = [Sport]()
    var selectedPrice = [PriceUnits]()
}
