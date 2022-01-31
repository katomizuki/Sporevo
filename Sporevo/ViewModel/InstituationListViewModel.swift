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
    var didLoad: PublishRelay<Void> { get }
}

protocol InstituationViewModelOutputs {
    var reload: PublishSubject<Void> { get }
    var errorHandling: PublishRelay<Error> { get }
    var facilitiesRelay: BehaviorRelay<[Facility]> { get }
}

protocol InstituationViewModelType {
    var inputs:InstituationViewModelInputs { get }
    var outputs: InstituationViewModelOutputs { get }
}

final class InstituationListViewModel:InstituationViewModelInputs,InstituationViewModelOutputs,InstituationViewModelType {
     
    var inputs: InstituationViewModelInputs { return self }
    var outputs: InstituationViewModelOutputs { return self }
    
    let willAppear = PublishRelay<Void>()
    let willDisAppear = PublishRelay<Void>()
    let didLoad = PublishRelay<Void>()
    let reload = PublishSubject<Void>()
    let errorHandling = PublishRelay<Error>()
    
    private let disposeBag = DisposeBag()
    private let store:Store<AppState>
    let facilitiesRelay = BehaviorRelay<[Facility]>(value: [])
    let actionCreator: FacilityListActionCreator
    
    init(store: Store<AppState>,actionCreator: FacilityListActionCreator) {
        self.store = store
        self.actionCreator = actionCreator
        
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subscription in
                subscription.select { state in state.instituationListState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
        
        didLoad.subscribe(onNext: { [unowned self] _ in
            self.actionCreator.getInstituatonList()
        }).disposed(by: disposeBag)
    }
    
    var numberOfCells: Int {
        return facilitiesRelay.value.count
    }

    
    private func setupFacilities(id: Int) {
        self.actionCreator.getInstituationDetail(id: id)
    }
    
    func facility(row: Int) -> Facility {

        return facilitiesRelay.value[row]
    }
    
    func searchFacilies(facilities: Facilities) {
        self.facilitiesRelay.accept(facilities.facilities)
        self.reload.onNext(())
    }
    
}
extension InstituationListViewModel:StoreSubscriber {
    
    typealias StoreSubscriberStateType = FacilityListState
    
    func newState(state: FacilityListState) {
        guard let list = state.facilities?.facilities else { return }
        facilitiesRelay.accept(list)
        reload.onNext(())
    }
}

