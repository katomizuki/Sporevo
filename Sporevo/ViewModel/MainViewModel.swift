//
//  SporevoMainViewModel.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/28.
//

import RxSwift
import ReSwift
import RxRelay

protocol MainViewModelInputs {
    var willAppear: PublishRelay<Void> { get }
    var willDisAppear: PublishRelay<Void> { get }
    var didLoad: PublishRelay<Void> { get }
    func didTapDetailSearchButton()
    func didTapSegment(index:Int)
    func dismiss(_ controller:FacilityListController)
}

protocol MainViewModelOutputs {
    var reload: PublishRelay<Void> { get }
    var errorHandling: PublishRelay<Error> { get }
    var toDetail: PublishSubject<Void> { get }
    var segmentIndex: PublishRelay<Int> { get }
}

protocol MainViewModelType {
    var inputs: MainViewModelInputs { get }
    var outputs: MainViewModelOutputs { get }
}

final class MainViewModel:MainViewModelType, MainViewModelOutputs,MainViewModelInputs {
    
    var willAppear = PublishRelay<Void>()
    
    var didLoad = PublishRelay<Void>()
    
    var willDisAppear = PublishRelay<Void>()
    
    var reload = PublishRelay<Void>()
    
    var errorHandling = PublishRelay<Error>()
    
    var segmentIndex = PublishRelay<Int>()
    var toDetail = PublishSubject<Void>()
    
    var inputs: MainViewModelInputs { return self }
    var outputs: MainViewModelOutputs { return self }
    
    private let disposeBag = DisposeBag()
    private let store:Store<AppState>
    private let repositry: FacilityRepositry
    private var facility:Facilities?
    
    init(store: Store<AppState>,repositry: FacilityRepositry) {
        self.store = store
        self.repositry = repositry
        
        didLoad.subscribe(onNext: { _  in
            if UserDefaults.standard.object(forKey: "isLocalDB") == nil {
                FacilityTypeRepositryImpl().saveFacility()
                SportsRepositryImpl().saveSports()
                MoneyRepositryImpl().saveMoney()
                TagRepositryImpl().saveTags()
                FetchPrefecture().savePrefecture()
                FacilityRepositryImpl().saveFacility()
            }
            UserDefaults.standard.set(true, forKey: "isLocalDB")
        }).disposed(by: disposeBag)

        
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.mainState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
        

    }
    
    func didTapDetailSearchButton() {
        self.toDetail.onNext(())
    }
    
    func didTapSegment(index:Int) {
        self.segmentIndex.accept(index)
    }
    
    func dismiss(_ controller: FacilityListController) {
        self.repositry.fetchFacility().subscribe { facility in
            self.facility = facility
            controller.facilities = facility
        } onFailure: { error in
            self.errorHandling.accept(error)
        }.disposed(by: disposeBag)
    }
}
extension MainViewModel: StoreSubscriber {
    
    typealias StoreSubscriberStateType = MainState
    
    func newState(state: MainState) {
        
    }
}
