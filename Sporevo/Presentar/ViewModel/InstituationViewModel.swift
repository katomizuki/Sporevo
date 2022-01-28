//
//  InstituationViewModel.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/28.
//

import RxSwift
import ReSwift
import RxRelay

protocol InstituationViewModelInputs {
    var willAppear: PublishRelay<Void> { get }
    var willDisAppear: PublishRelay<Void> { get }
}

protocol InstituationViewModelOutputs {
    
}

protocol InstituationViewModelType {
    var inputs:InstituationViewModelInputs { get }
    var outputs: InstituationViewModelOutputs { get }
}

final class InstituationViewModel:InstituationViewModelInputs,InstituationViewModelOutputs,InstituationViewModelType {
     
    var inputs: InstituationViewModelInputs { return self }
    var outputs: InstituationViewModelOutputs { return self }
    
    let willAppear = PublishRelay<Void>()
    let willDisAppear = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    private let store:Store<AppState>
    
    init(store: Store<AppState>) {
        self.store = store
        
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subscription in
                subscription.select { state in state.facilityDetailState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)


    }
    
    
}
extension InstituationViewModel:StoreSubscriber {
    
    typealias StoreSubscriberStateType = FacilityDetailState
    
    func newState(state: FacilityDetailState) {
        
    }
}

