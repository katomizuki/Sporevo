import Foundation

protocol SearchListInputs {
    func viewDidLoad(_ tojudgeKeywordOptions: SearchOptions)
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
    private let model:FetchFacilityTypeInputs
    private var option:SearchOptions!
    private let sportsInput:FetchSportsInputs
    private let tagsInput:FetchTagInputs
    private let moneyInput:FetchMoneyInputs
    private let prefectureInput:FetchPrefectureInputs
    private let cityInput:FetchCityInputs
    init(outputs:SearchListOutputs,
         model:FetchFacilityTypeInputs,
         option:SearchOptions,
         sports:FetchSportsInputs,
         tags:FetchTagInputs,
         moneyUnit:FetchMoneyInputs,
         prefecture:FetchPrefectureInputs,
         city:FetchCityInputs) {
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
        case .institution: return facilities.count
        case .competition: return sports.count
        case .price:
            let section = moneySections[section]
            if section.isOpened {
                return section.prices.count + 1
            } else {
                return 1
            }
        case .tag: return tags.count
        case .none: return 0
        }
    }
    private func fetchPrefecture() {
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
            case.failure(let error): print(error)
            }
        }
    }
    
    private func fetchFacility() {
        model.fetchFacility { result in
            switch result {
            case .success(let models):
                self.facilities = models
                self.outputs.reload()
            case .failure(let error): print(error)
            }
        }
    }
    private func fetchSports() {
        sportsInput.fetchSports { result in
            switch result {
            case .success(let models):
                self.sports = models
                self.outputs.reload()
            case .failure(let error): print(error)
        }
     }
  }
    private func fetchMoney() {
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
                        case .failure(let error): print(error)
                        }
                    }
                }
                group.notify(queue: .main) {
                    self.outputs.reload()
                }
            case .failure(let error): print(error)
            }
        }
    }
    private func fetchTags() {
        tagsInput.fetchTags { result in
            switch result {
            case .success(let tags):
                self.tags = tags
                self.outputs.reload()
            case .failure(let error): print(error)
            }
        }
    }

    func viewDidLoad(_ tojudgeKeywordOptions: SearchOptions) {
        switch tojudgeKeywordOptions {
        case .place:
            fetchPrefecture()
        case .institution:
            fetchFacility()
        case .competition:
            fetchSports()
        case .price:
            fetchMoney()
        case .tag:
            fetchTags()
        }
    }
    func didSelectRowAt(indexPath:IndexPath) {
        let id = indexPath.row
        let sectionId = indexPath.section
        switch option {
        case .place:
            if id == 0 { return }
            let city = citySections[sectionId].items[id - 1]
            if judgeArray(ele: city, array: selectedCity) {
                selectedCity.append(city)
            } else {
                selectedCity.remove(value: city)
            }
        case .institution:
            if judgeArray(ele: facilities[id], array: selectedInstion) == true {
                selectedInstion.append(facilities[id])
            } else {
                selectedInstion.remove(value: facilities[id])
            }
        case .competition:
            if judgeArray(ele: sports[id], array: selectedCompetion) == true {
                selectedCompetion.append(sports[id])
            } else {
                selectedCompetion.remove(value: sports[id])
            }
        case .price:
            if id == 0 { return }
            let price = moneySections[sectionId].prices[id - 1]
            if judgeArray(ele: price, array: selectedPrice) {
                selectedPrice.append(price)
            } else {
                selectedPrice.remove(value: price)
            }
        case .tag:
            if judgeArray(ele: tags[id], array: selectedTag) == true {
                selectedTag.append(tags[id])
            } else {
                selectedTag.remove(value: tags[id])
            }
        default:break
        }
    }
    func saveUserDefaults() {
        switch option {
        case .place:
            UserDefaultRepositry.shared.saveToUserDefaults(element: selectedCity, key: "city")
        case .institution:
            UserDefaultRepositry.shared.saveToUserDefaults(element: selectedInstion, key: "facility")
        case .competition:
            UserDefaultRepositry.shared.saveToUserDefaults(element: selectedCompetion, key: "sport")
        case .price:
            UserDefaultRepositry.shared.saveToUserDefaults(element: selectedPrice, key: "priceUnits")
        case .tag:
            UserDefaultRepositry.shared.saveToUserDefaults(element: selectedTag, key: "tag")
        default:break
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
        case .institution: message = self.facilities[row].name
        case.competition: message = self.sports[row].name
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
        case .none: break
        }
        return message
    }
}
extension SearchListPresentar {
    private func judgeArray<T:Equatable>(ele:T,array:[T])->Bool {
        return array.filter({ $0 == ele }).count == 0
    }
}
