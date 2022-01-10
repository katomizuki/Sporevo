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
        return state
    }
}
