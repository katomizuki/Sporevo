import Foundation

protocol SearchListInputs {
    func viewDidLoad(_ tojudgeKeywordOptions:SearchOptions)
    func numberOfCell(section:Int)->Int
    func didSelectRowAt(id:Int)
    func prefecture(row:Int)->Prefecture
    func facility(row:Int)->FacilityType
    func sport(row:Int)-> Sport
    func tag(row: Int)->Tag
    func moneyUnit(row:Int)->MoneyUnits
    func saveUserDefaults()
    var sectionsCount:Int { get }
    func sectionTitle(section:Int) ->Prefecture
    func didTapPlaceSection(section:Int)
    func cityies(section:Int)->[City]
    func sectionMoneyUnit(section:Int)-> MoneyUnits
    func prices(section:Int)->[PriceUnits]
}
protocol SearchListOutputs:AnyObject {
    func reload()
    func reloadSections(section:Int)
    func detailListController(id:Int)
}

final class SearchListPresentar:SearchListInputs {
    // MARK: - Properties
    private var selectedCity = [String]()
    var selectedTag = [Tag]()
    var selectedInstion = [FacilityType]()
    var selectedCompetion = [Sport]()
    private var selectedPrice = [String]()
    private var facilities = [FacilityType]()
    private var sports = [Sport]()
    private var tags = [Tag]()
    private var moneyUnit = [MoneyUnits]()
    private var prefectures = [Prefecture]()
    private var citySections = [CitySection]()
    private var moneySections = [MoneySection]()
    private weak var outputs:SearchListOutputs!
    private var model:FetchFacilityTypeInputs!
    private var option:SearchOptions!
    private var sportsInput:FetchSportsInputs!
    private var tagsInput:FetchTagInputs!
    private var moneyInput:FetchMoneyInputs!
    private var prefectureInput:FetchPrefectureInputs!
    private var cityInput:FetchCityInputs!
    init(outputs:SearchListOutputs,model:FetchFacilityTypeInputs,option:SearchOptions,sports:FetchSportsInputs,tags:FetchTagInputs,moneyUnit:FetchMoneyInputs,prefecture:FetchPrefectureInputs,city:FetchCityInputs) {
        self.outputs = outputs
        self.model = model
        self.option = option
        self.sportsInput = sports
        self.tagsInput = tags
        self.moneyInput = moneyUnit
        self.prefectureInput = prefecture
        self.cityInput = city
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
    func numberOfCell(section:Int)->Int {
        switch option {
        case .place:
            //sectionsが流れてくるので、isOpendで開いているかどうかをチャックする、しまっていたら1を返す。
            let section = citySections[section]
            if section.isOpened {
                return section.items.count + 1
            } else {
                return 1
            }
        case .institution:
            return facilities.count
        case .competition:
            return sports.count
        case .price:
            let section = moneySections[section]
            if section.isOpened {
                return section.prices.count + 1
            } else {
                return 1
            }
        case .tag:
            return tags.count
        case .none:
            return 0
        }
    }

    func viewDidLoad(_ tojudgeKeywordOptions: SearchOptions) {
        switch tojudgeKeywordOptions {
        case .place:
            prefectureInput.fetchPrefecture { result in
                switch result {
                case .success(let prefecture):
                    self.prefectures = prefecture
                    let group = DispatchGroup()
                    prefecture.forEach { pre in
                        group.enter()
                        let id = Int(exactly: pre.id)!
                        self.cityInput.fetchCities(id: id) { result in
                            switch result {
                            case .success(let city):
                                defer { group.leave() }
                                let section = CitySection(pre: pre, items: city)
                                self.citySections.append(section)
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                    group.notify(queue: .main) {
                        self.outputs.reload()
                    }
                case.failure(let error):
                    print(error)
                }
            }
        case .institution:
            model.fetchFacility { result in
                switch result {
                case .success(let models):
                    self.facilities = models
                    self.outputs.reload()
                case .failure(let error): print(error)
                }
            }
        case .competition:
            sportsInput.fetchSports { result in
                switch result {
                case .success(let models):
                    self.sports = models
                    self.outputs.reload()
                case .failure(let error):
                    print(error)
            }
         }
        case .price:
            moneyInput.fetchMoney { result in
                switch result {
                case .success(let moneyUnits):
                    self.moneyUnit = moneyUnits
                    let group = DispatchGroup()
                    moneyUnits.forEach { unit in
                        group.enter()
                        let id = unit.id
                        self.moneyInput.fetchMoney(index: id) { result in
                            group.leave()
                            switch result {
                            case .success(let priceUnits):
                                let section = MoneySection(units: unit, prices: priceUnits)
                                self.moneySections.append(section)
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                    group.notify(queue: .main) {
                        self.outputs.reload()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case .tag:
            tagsInput.fetchTags { result in
                switch result {
                case .success(let tags):
                    self.tags = tags
                    self.outputs.reload()
                case .failure(let error):
                    print(error)
                }
            }
        }
       

    }
    func didSelectRowAt(id:Int) {
        if option == .place || option == .price {
            outputs.detailListController(id:id)
        }
        if option == .institution {
            if judgeArray(ele: facilities[id], array: selectedInstion) == true {
                selectedInstion.append(facilities[id])
            } else {
                selectedInstion.remove(value: facilities[id])
            }
        }
        if option == .competition {
            if judgeArray(ele: sports[id], array: selectedCompetion) == true {
                selectedCompetion.append(sports[id])
            } else {
                selectedCompetion.remove(value: sports[id])
            }
        }
        if option == .tag {
            if judgeArray(ele: tags[id], array: selectedTag) == true {
                selectedTag.append(tags[id])
            } else {
                selectedTag.remove(value: tags[id])
            }
        }
    }
    func facility(row: Int) -> FacilityType {
        return facilities[row]
    }
    func sport(row: Int)-> Sport {
        return sports[row]
    }
    func tag(row:Int) -> Tag {
        return tags[row]
    }
    func moneyUnit(row:Int)->MoneyUnits {
        return moneyUnit[row]
    }
    func prefecture(row:Int)->Prefecture {
        return prefectures[row]
    }
    func sectionTitle(section: Int) -> Prefecture {
        return citySections[section].pre
    }
    func sectionMoneyUnit(section:Int)-> MoneyUnits {
        return moneySections[section].units
    }
    func saveUserDefaults() {
        if option == .institution {
            UserDefaultRepositry.shared.saveToUserDefaults(element: selectedInstion, key: "facility")
        }
        if option == .tag {
            UserDefaultRepositry.shared.saveToUserDefaults(element: selectedTag, key: "tag")
        }
        if option == .competition {
            UserDefaultRepositry.shared.saveToUserDefaults(element: selectedCompetion, key: "sport")
        }
    }
    func didTapPlaceSection(section: Int) {
        if option == .place {
            citySections[section].isOpened = !citySections[section].isOpened
        } else {
            moneySections[section].isOpened = !moneySections[section].isOpened
        }
        self.outputs.reloadSections(section: section)
    }
    func cityies(section: Int) -> [City] {
        return citySections[section].items
    }
    func prices(section:Int)->[PriceUnits] {
        return moneySections[section].prices
    }
}
extension SearchListPresentar {
    private func judgeArray<T:Equatable>(ele:T,array:[T])->Bool {
        return array.filter({ $0 == ele }).count == 0
    }
}
