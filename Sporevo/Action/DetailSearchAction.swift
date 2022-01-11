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
        case saveUserDefaults(option: SearchOptions)
        case cityTap(id:Int,sectionId: Int)
        case sportTap(id:Int)
        case tagTap(id:Int)
        case institutionTap(id:Int)
        case moneyTap(id:Int,sectionId: Int)
        case tapSectionMoney(section:Int)
        case tapSectionPlace(section:Int)
    }
}
