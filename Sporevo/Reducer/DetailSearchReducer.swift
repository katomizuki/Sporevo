//
//  DetailSearchReducer.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/10.
//

import ReSwift
struct DetailSearchReducer {
    
    static func reducer(action: ReSwift.Action, state:DetailSearchState?)->DetailSearchState {
        var state = state ?? DetailSearchState()
        guard let action = action as? DetailSearchState.DetailSearchAction else { return state }
        switch action {
        case .setPlaceSection(section: let sections):
            state.placeSections = sections
        case .setTags(tags: let tags):
            state.tags = tags
        case .setSports(sports: let sports):
            state.sports = sports
        case .setFacilityType(types: let types):
            state.facilityType = types
        case .setMoneySections(sections: let sections):
            state.moneySections = sections
        case .saveUserDefaults(option: let option):
            switch option {
            case .place:
                UserDefaultRepositry.shared.saveToUserDefaults(element: state.selectedCity, key: "city")
            case .institution:
                UserDefaultRepositry.shared.saveToUserDefaults(element: state.selectedInstion, key: "facility")
            case .competition:
                UserDefaultRepositry.shared.saveToUserDefaults(element: state.selectedCompetion, key: "sport")
            case .price:
                UserDefaultRepositry.shared.saveToUserDefaults(element: state.selectedPrice, key: "priceUnits")
            case .tag:
                UserDefaultRepositry.shared.saveToUserDefaults(element: state.selectedTag, key: "tag")
            }
        case .cityTap(id: let id, sectionId: let sectionId):
            let city = state.placeSections[sectionId].items[id - 1]
            if DetailSearchReducer.judgeArray(ele: city, array: state.selectedCity) {
                state.selectedCity.append(city)
            } else {
                state.selectedCity.remove(value: city)
            }
        case .sportTap(id: let id):
            if DetailSearchReducer.judgeArray(ele: state.sports[id], array: state.selectedCompetion) == true {
                state.selectedCompetion.append(state.sports[id])
            } else {
                state.selectedCompetion.remove(value: state.sports[id])
            }
        case .tagTap(id: let id):
            if DetailSearchReducer.judgeArray(ele: state.tags[id], array: state.selectedTag) == true {
                state.selectedTag.append(state.tags[id])
            } else {
                state.selectedTag.remove(value: state.tags[id])
            }
        case .moneyTap(id: let id, sectionId: let sectionId):
            let price = state.moneySections[sectionId].prices[id - 1]
            if DetailSearchReducer.judgeArray(ele: price, array: state.selectedPrice) {
                state.selectedPrice.append(price)
            } else {
                state.selectedPrice.remove(value: price)
            }
        case .institutionTap(id: let id):
            if DetailSearchReducer.judgeArray(ele: state.facilityType[id], array:state.selectedInstion) == true {
                state.selectedInstion.append(state.facilityType[id])
            } else {
                state.selectedInstion.remove(value: state.facilityType[id])
            }
        case .tapSectionMoney(section: let section):
            state.moneySections[section].isOpened = !state.moneySections[section].isOpened
        case .tapSectionPlace(section: let section):
            state.placeSections[section].isOpened = !state.placeSections[section].isOpened
        }
        return state
    }
    
    static func judgeArray<T:Equatable>(ele:T,array:[T])->Bool {
        return array.filter({ $0 == ele }).count == 0
    }
}

