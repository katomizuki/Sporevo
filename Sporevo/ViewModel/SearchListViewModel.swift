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
    var reload: PublishSubject<Void> { get }
}

protocol FacilitySearchViewModelType {
    var inputs:FacilitySearchViewModelInput { get }
    var outputs:FacilitySearchViewModelOutput { get }
}

final class SearchListViewModel:FacilitySearchViewModelType,FacilitySearchViewModelOutput,FacilitySearchViewModelInput {
    
    private let disposeBag = DisposeBag()
    private let store:Store<AppState>
    
    var inputs: FacilitySearchViewModelInput { return self }
    var outputs: FacilitySearchViewModelOutput { return self }
    
    let willAppear = PublishRelay<Void>()
    let willDisAppear = PublishRelay<Void>()
    let reload = PublishSubject<Void>()
    
    var selectedTag = [Tag]()
    var selectedSports = [Sport]()
    var selectedFacility = [FacilityType]()
    var selectedPriceUnits = [PriceUnits]()
    var selectedCity = [City]()
    
    init(store:Store<AppState>) {
        self.store = store
        
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subscription in
                subscription.select { state in
                    state.searchListState
                }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)


    }
    func loadUserDefaults() {
        SearchListActionCreator.loadUserDefaults()
    }
    
    func getSelectedMessage(row: Int) -> String {
        var message = String()
        switch row {
        case 0: if selectedCity.count == 0 { return "" }
            selectedCity.forEach{ message += "　\($0.name)"}
        case 1:
            if selectedFacility.count == 0 { return "" }
            selectedFacility.forEach { message += "　\($0.name)"}
        case 2:
            if selectedSports.count == 0 { return "" }
            selectedSports.forEach { message += "　\($0.name)" }
        case 3:
            if selectedPriceUnits.count == 0 { return "" }
            selectedPriceUnits.forEach{ message += "  \($0.name)" }
        case 4:
            if selectedTag.count == 0 { return "" }
            selectedTag.forEach { message += "　\($0.name)" }
        default:return ""
        }
        return message
    }
    
    func deleteUserDefaults() {
        SearchListActionCreator.deleteUserDefaults()
    }
    
}
extension SearchListViewModel: StoreSubscriber {
    
    typealias StoreSubscriberStateType = SearchListState
    
    func newState(state: SearchListState) {
        self.selectedCity = state.selectedCity
        self.selectedTag = state.selectedTag
        self.selectedSports = state.selectedSports
        self.selectedPriceUnits = state.selectedPriceUnits
        self.selectedFacility = state.selectedFacility
        reload.onNext(())
    }
}
