import Foundation

protocol DetailSearchInputs {
    func viewdidLoad()
    func city(row:Int)->City
    var numberOfCell:Int { get }
}
protocol DetailSearchOutputs:AnyObject {
    func reload()
}

final class DetailSearchPresentar:DetailSearchInputs {
    // MARK: - Properties
    private weak var outputs:DetailSearchOutputs?
    private var cities = [City]()
    private var cityInputs:FetchCityInputs!
    private var option:SearchOptions
    private var apiID:Int?
    // MARK: - Initialize
    init(output:DetailSearchOutputs,city:FetchCityInputs,option:SearchOptions,apiID:Int) {
        self.outputs = output
        self.cityInputs = city
        self.option = option
        self.apiID = apiID
    }
    var numberOfCell: Int {
        if option == .place {
            return cities.count
        } else if option == .price {
            return 1
        }
        return 0
    }
    
    func viewdidLoad() {
        guard let apiID = apiID else {
            return
        }
        if option == .place {
            cityInputs.fetchCities(id: apiID) { result in
                switch result {
                case .success(let cities):
                    self.cities = cities
                    print(cities.count)
                    self.outputs?.reload()
                case .failure(let error):
                    print(error)
                }
            }
        } else if option == .price {
            
        }
    }
    func city(row: Int) -> City {
        return cities[row]
    }
}
