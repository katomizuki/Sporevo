//
//  SearchPresentarViewModel.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/28.
//

import RxSwift
import RxRelay
import ReSwift

protocol DetailSearchViewModelInput {
    var willAppear:PublishRelay<Void> { get }
    var willDisAppear: PublishRelay<Void> { get }
    var didLoad: PublishRelay<Void> { get }
}

protocol DetailSearchViewModelOutput {
    var sectionsCount: Int { get }
    func numberOfCell(section:Int) -> Int
    var reload: PublishRelay<Void> { get }
    var reloadSections: PublishSubject<Int> { get }
}

protocol DetailSearchViewModelType {
    var inputs: DetailSearchViewModelInput { get }
    var outputs: DetailSearchViewModelOutput { get }
}

final class DetailSearchViewModel: DetailSearchViewModelType,DetailSearchViewModelInput,DetailSearchViewModelOutput {
    
    let willDisAppear = PublishRelay<Void>()
    
    let willAppear = PublishRelay<Void>()
    
    let didLoad = PublishRelay<Void>()
    
    var reload = PublishRelay<Void>()
    
    var reloadSections = PublishSubject<Int>()
    
    
    var inputs: DetailSearchViewModelInput { return self }
    
    var outputs: DetailSearchViewModelOutput { return self }
    
    private let disposeBag = DisposeBag()
    private let store:Store<AppState>
    private var citySections = [CitySection]()
    private var moneySections = [MoneySection]()
    private var selectedCity = [City]()
    private var selectedTag = [Tag]()
    private var selectedInstion = [FacilityType]()
    private var selectedCompetion = [Sport]()
    private var selectedPrice = [PriceUnits]()
    private var facilityType = [FacilityType]()
    private var sports = [Sport]()
    private var tags = [Tag]()
    private let option:SearchOptions
    
    init(store: Store<AppState>,option: SearchOptions) {
        self.store = store
        self.option = option
        
        didLoad.subscribe(onNext: { [unowned self] _  in
            self.setupData()
        }).disposed(by: disposeBag)

        
        
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.detailSearchState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    var sectionsCount: Int {
        if option == .place {
            return citySections.count
        } else if option == .price {
            return moneySections.count
        } else {
            return 1
        }
    }
    
    func setupData() {
        switch option {
        case .place:
            DetailSearchActionCreator.fetchPrefecture()
        case .institution:
            DetailSearchActionCreator.fetchFacilityType()
        case .competition:
            DetailSearchActionCreator.fetchSport()
        case .price:
            DetailSearchActionCreator.fetchMoneySections()
        case .tag:
            DetailSearchActionCreator.fetchTag()
        }
    }
    
    func didSelectRowAt(indexPath:IndexPath) {
        DetailSearchActionCreator.didSelectRowAt(option: option, indexPath: indexPath)
    }
    
    func saveUserDefaults() {
        DetailSearchActionCreator.saveUserDefaults(option: option)
    }
    
    func didTapSection(section: Int) {
        DetailSearchActionCreator.didTapSection(section: section, option: option)
        self.outputs.reloadSections.onNext(section)
    }
    
    func numberOfCell(section:Int) -> Int {
        switch option {
        case .place:
            //sectionsが流れてくるので、isOpendで開いているかどうかをチャックする、しまっていたら1を返す。
            let section = citySections[section]
            if section.isOpened {
                return section.items.count + 1
            } else {
                return 1
            }
        case .institution: return facilityType.count
        case .competition: return sports.count
        case .price:
            let section = moneySections[section]
            if section.isOpened {
                return section.prices.count + 1
            } else {
                return 1
            }
        case .tag: return tags.count
        }
    }
    
    func getMessage(indexPath: IndexPath) -> String {
        let row = indexPath.row
        let section = indexPath.section
        var message = String()
        switch option {
        case .institution: message = self.facilityType[row].name
        case .competition: message = self.sports[row].name
        case .place:
            let model = self.citySections[section].pre
            if row == 0 {
                message = model.name
            } else {
                let cities = self.citySections[section].items
                message = cities[row - 1].name
            }
        case .price:
            let model = self.moneySections[section].units
            if row == 0 {
                message = model.name
            } else {
                let prices = self.moneySections[section].prices
                message = prices[row - 1].name
            }
        case .tag: message = self.tags[row].name
        }
        return message
    }
}

extension DetailSearchViewModel: StoreSubscriber {
    
    typealias StoreSubscriberStateType = DetailSearchState
    
    func newState(state: DetailSearchState) {
        self.facilityType = state.facilityType
        self.moneySections = state.moneySections
        self.sports = state.sports
        self.tags = state.tags
        self.citySections = state.placeSections
        reload.accept(())
    }
    
}
