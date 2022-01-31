//
//  MainReducer.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/29.
//

import ReSwift

struct MainReducer {
    static func reducer(action: ReSwift.Action, state:MainState?) -> MainState {
        let state = state ?? MainState()
        guard let action = action as? MainState.MainStateAction else { return state }
        switch action {
        case .tap:
            print(#function)
        }
        return state

    }
}
