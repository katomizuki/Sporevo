import Foundation

protocol DetailSearchInputs {
    func viewdidLoad()
    func city(row:Int)->City
    func priceUnit(row:Int)->PriceUnits
    var numberOfCell:Int { get }
}
protocol DetailSearchOutputs:AnyObject {
    func reload()
}

final class DetailSearchPresentar:DetailSearchInputs {
    // MARK: - Properties
    private weak var outputs:DetailSearchOutputs?
    private var cities = [City]()
    private var priceUnits = [PriceUnits]()
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
}
