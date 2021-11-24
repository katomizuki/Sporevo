import Foundation

protocol DetailSearchInputs {
    func viewdidLoad()
}
protocol DetailSearchOutputs:AnyObject {
    
}

struct DetailSearchPresentar:DetailSearchInputs {
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
    func viewdidLoad() {
        
    }
    
}
