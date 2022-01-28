//
//  SporevoMainViewModel.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/28.
//

import RxSwift
import ReSwift
import RxRelay

protocol SporevoMainViewModelInputs {
    var willAppear: PublishRelay<Void> { get }
    var willDisAppear: PublishRelay<Void> { get }
}

protocol SporevoMainViewModelOutputs {
    
}

protocol SporevoMainViewModelType {
    var inputs: SporevoMainViewModelInputs { get }
    var outputs: SporevoMainViewModelOutputs { get }
}

final class SporevoMainViewModel:SporevoMainViewModelType, SporevoMainViewModelOutputs,SporevoMainViewModelInputs {
    var willAppear = PublishRelay<Void>()
    
    var willDisAppear = PublishRelay<Void>()
    
    
    var inputs: SporevoMainViewModelInputs { return self }
    var outputs: SporevoMainViewModelOutputs { return self }
    
    private let disposeBag = DisposeBag()
    private let store:Store<AppState>
    
    init(store: Store<AppState>) {
        self.store = store
        
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.mapState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)


        
    }
    
    
}
extension SporevoMainViewModel: StoreSubscriber {
    
    typealias StoreSubscriberStateType = SporevoMapState
    
    func newState(state: SporevoMapState) {
        
    }
}
