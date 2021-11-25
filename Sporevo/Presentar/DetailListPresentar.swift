import Foundation

protocol DetailSearchInputs {
    func viewdidLoad()
    func city(row:Int)->City
    func priceUnit(row:Int)->PriceUnits
    var numberOfCell:Int { get }
    func didTapCell(row:Int)
    func saveUserDefaults()
}
protocol DetailSearchOutputs:AnyObject {
    func reload()
}

final class DetailListPresentar:DetailSearchInputs {
    // MARK: - Properties
    private weak var outputs:DetailSearchOutputs?
    private var cities = [City]()
    private var priceUnits = [PriceUnits]()
    private var selectedCity = [City]()
    private var selectedPriceUnits = [PriceUnits]()
    private var cityInputs:FetchCityInputs!
    private var priceUnitsInputs:FetchMoneyInputs!
    private var option:SearchOptions
    private var apiID:Int?
    // MARK: - Initialize
    init(output:DetailSearchOutputs,city:FetchCityInputs,priceUnit:FetchMoneyInputs,option:SearchOptions,apiID:Int) {
        self.outputs = output
        self.cityInputs = city
        self.option = option
        self.apiID = apiID
        self.priceUnitsInputs = priceUnit
    }
    var numberOfCell: Int {
        if option == .place {
            return cities.count
        } else if option == .price {
            return priceUnits.count
        }
        return 0
    }
    
    func viewdidLoad() {
        guard let apiID = apiID else {
            return
        }
        if option == .place {
            cityInputs.fetchCities(id: apiID) { [weak self] result in
                switch result {
                case .success(let cities):
                    self?.cities = cities
                    print(cities.count)
                    self?.outputs?.reload()
                case .failure(let error):
                    print(error)
                }
            }
        } else if option == .price {
            priceUnitsInputs.fetchMoney(index: apiID) { [weak self] result in
                switch result {
                case .success(let priceUnits):
                    self?.priceUnits = priceUnits
                    self?.outputs?.reload()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    func city(row: Int) -> City {
        return cities[row]
    }
    func priceUnit(row: Int) -> PriceUnits {
        return priceUnits[row]
    }
    func didTapCell(row: Int) {
        if option == .place {
            if judgeArray(ele: cities[row], array: selectedCity) == true {
                selectedCity.append(cities[row])
            } else {
                selectedCity.remove(value: cities[row])
            }
        } else if option == .price {
            if judgeArray(ele: priceUnits[row], array: selectedPriceUnits) == true {
                selectedPriceUnits.append(priceUnits[row])
            } else {
                selectedPriceUnits.remove(value: priceUnits[row])
            }
        }
    }
    func saveUserDefaults() {
        var cities:[City] = UserDefaultRepositry.shared.loadFromUserDefaults(key: "city")
        var priceUnits:[PriceUnits] = UserDefaultRepositry.shared.loadFromUserDefaults(key: "priceUnits")

        if cities.count == 0 {
            UserDefaultRepositry.shared.saveToUserDefaults(element: selectedCity, key: "city")
        } else {
            cities = cities + selectedCity
            UserDefaultRepositry.shared.saveToUserDefaults(element: cities, key: "city")
        }
        if priceUnits.count == 0 {
            UserDefaultRepositry.shared.saveToUserDefaults(element: selectedPriceUnits, key: "priceUnits")
        } else {
            priceUnits += selectedPriceUnits
            UserDefaultRepositry.shared.saveToUserDefaults(element: selectedPriceUnits, key: "priceUnits")
        }
        
    }
}
extension DetailListPresentar {
    func judgeArray<T:Equatable>(ele:T,array:[T])->Bool {
        return array.filter({ $0 == ele }).count == 0
    }
}

