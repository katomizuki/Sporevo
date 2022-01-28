//
//  SearchPresentarViewModel.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/28.
//

import RxSwift
import RxRelay
import ReSwift

protocol SearchListViewModelInput {
    var willAppear:PublishRelay<Void> { get }
    var willDisAppear: PublishRelay<Void> { get }
}

protocol SearchListViewModelOutput {
    
}

protocol SearchListViewModelType {
    var inputs: SearchListViewModelInput { get }
    var outputs: SearchListViewModelOutput { get }
}

final class SearchListViewModel: SearchListViewModelType,SearchListViewModelInput,SearchListViewModelOutput {
    
    let willDisAppear = PublishRelay<Void>()
    
    let willAppear = PublishRelay<Void>()
    
    
    var inputs: SearchListViewModelInput { return self }
    
    var outputs: SearchListViewModelOutput { return self }
    
    private let disposeBag = DisposeBag()
    private let store:Store<AppState>
    
    init(store: Store<AppState>) {
        self.store = store
        
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.facilitySearchState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)

    }
}

extension SearchListViewModel: StoreSubscriber {
    
    typealias StoreSubscriberStateType = FacilitySearchState
    
    func newState(state: FacilitySearchState) {
        
    }
    
}
