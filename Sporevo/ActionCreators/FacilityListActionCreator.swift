//
//  InstituationListActionCreator.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/29.
//


import ReSwift

struct FacilityListActionCreator {

    static func getInstituationDetail(id: Int) {
        FacilityRepositryImpl.getFacilityDetail(id: id).subscribe { detail in
//            appStore.dispatch(Ins)
        } onFailure: { error in
            print(error)
        }
    }
}
