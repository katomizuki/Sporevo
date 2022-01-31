//
//  InstituationListActionCreator.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/29.
//


import ReSwift
import RxSwift

struct FacilityListActionCreator {
    let repositry: FacilityRepositry
    private let disposeBag = DisposeBag()
     func getInstituationDetail(id: Int) {
        FacilityRepositryImpl.getFacilityDetail(id: id).subscribe { detail in
//            appStore.dispatch(Ins)
        } onFailure: { error in
            print(error)
        }
    }
     func getInstituatonList() {
         self.repositry.fetchFacility().subscribe { facility in
             appStore.dispatch(FacilityListState.FacilityListAction.getFacilityList(facilities: facility))
         } onFailure: { error in
             print(error)
         }.disposed(by: disposeBag)

     }
}
