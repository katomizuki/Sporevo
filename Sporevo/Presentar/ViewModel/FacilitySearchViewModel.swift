//
//  FacilitySearchViewModel.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/28.
//

import RxSwift
import RxRelay
import ReSwift

protocol FacilitySearchViewModelInput {
    var willAppear: PublishRelay<Void> { get }
    var willDisAppear: PublishRelay<Void> { get }
}

protocol FacilitySearchViewModelOutput {
    
}

protocol FacilitySearchViewModelType {
    var inputs:FacilitySearchViewModelInput { get }
    var outputs:FacilitySearchViewModelOutput { get }
}

final class FacilitySearchViewModel:FacilitySearchViewModelType,FacilitySearchViewModelOutput,FacilitySearchViewModelInput {
    
    private let disposeBag = DisposeBag()
    private let store:Store<AppState>
    
    var inputs: FacilitySearchViewModelInput { return self }
    var outputs: FacilitySearchViewModelOutput { return self }
    
    let willAppear = PublishRelay<Void>()
    let willDisAppear = PublishRelay<Void>()
    
    init(store:Store<AppState>) {
        self.store = store
        
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subscription in
                subscription.select { state in
                    state.facilitySearchState
                }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)


    }
    
}
extension FacilitySearchViewModel: StoreSubscriber {
    
    typealias StoreSubscriberStateType = FacilitySearchState
    
    func newState(state: FacilitySearchState) {
        
    }
}
