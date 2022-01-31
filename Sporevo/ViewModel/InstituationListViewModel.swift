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
    var facilities:Facilities?
    let repositry: FacilityRepositry
    
    init(store: Store<AppState>,repositry: FacilityRepositry) {
        self.store = store
        self.repositry = repositry
        
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subscription in
                subscription.select { state in state.instituationListState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
        
        didLoad.subscribe(onNext: { [unowned self] _ in
            self.repositry.fetchFacility { result in
                        switch result {
                        case .success(let facilities):
                            self.facilities = facilities
                            self.reload.onNext(())
                        case .failure(let error):
                            self.errorHandling.accept(error)
                        }
                    }
        }).disposed(by: disposeBag)
    }
    
    var numberOfCells: Int {
        return facilities?.facilities.count ?? 0
    }

    
    private func setupFacilities(id: Int) {
        FacilityListActionCreator.getInstituationDetail(id: id)
    }
    
    func facility(row: Int) -> Facility {
        guard let facilities = facilities else {
            fatalError()
        }
        return facilities.facilities[row]
    }
    
    func searchFacilies(facilities: Facilities) {
        self.facilities = facilities
        self.reload.onNext(())
    }
    
}
extension InstituationListViewModel:StoreSubscriber {
    
    typealias StoreSubscriberStateType = FacilityListState
    
    func newState(state: FacilityListState) {
        
    }
}

