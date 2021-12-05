import Foundation

protocol SearchListInputs {
    func viewDidLoad(_ tojudgeKeywordOptions:SearchOptions)
    func numberOfCell(section:Int)->Int
    func didSelectRowAt(indexPath:IndexPath)
    func saveUserDefaults()
    var sectionsCount:Int { get }
    func didTapSection(section:Int)
    func getMessage(indexPath:IndexPath)->String
}
protocol SearchListOutputs:AnyObject {
    func reload()
    func reloadSections(section:Int)
}

final class SearchListPresentar:SearchListInputs {
    
    // MARK: - Properties
    private var selectedCity = [City]()
    private var selectedTag = [Tag]()
    private var selectedInstion = [FacilityType]()
    private var selectedCompetion = [Sport]()
    private var selectedPrice = [PriceUnits]()
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
    func didSelectRowAt(indexPath:IndexPath) {
        let id = indexPath.row
        let sectionId = indexPath.section
        if option == .place  {
            if id == 0 { return }
            let city = citySections[sectionId].items[id - 1]
            if judgeArray(ele: city, array: selectedCity) {
                selectedCity.append(city)
            } else {
                selectedCity.remove(value: city)
            }
        }
        if option == .price {
            if id == 0 { return }
            let price = moneySections[sectionId].prices[id - 1]
            if judgeArray(ele: price, array: selectedPrice) {
                selectedPrice.append(price)
            } else {
                selectedPrice.remove(value: price)
            }
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
        if option == .place {
            UserDefaultRepositry.shared.saveToUserDefaults(element: selectedCity, key: "city")
        }
        if option == .price {
            UserDefaultRepositry.shared.saveToUserDefaults(element: selectedPrice, key: "priceUnits")
        }
    }
    func didTapSection(section: Int) {
        if option == .place {
            citySections[section].isOpened = !citySections[section].isOpened
        } else {
            moneySections[section].isOpened = !moneySections[section].isOpened
        }
        self.outputs.reloadSections(section: section)
        
    }
    func getMessage(indexPath: IndexPath) -> String {
        let row = indexPath.row
        let section = indexPath.section
        var message = String()
        switch option {
        case .institution:
            message = self.facilities[row].name
        case.competition:
            message = self.sports[row].name
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
        case .tag:
            message = self.tags[row].name
        case .none:
            break
        }
        return message
    }
}
extension SearchListPresentar {
    private func judgeArray<T:Equatable>(ele:T,array:[T])->Bool {
        return array.filter({ $0 == ele }).count == 0
    }
}
