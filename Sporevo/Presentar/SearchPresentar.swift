import Foundation
struct Model<T> {
    
}
protocol SearchListInputs {
    func viewDidLoad(_ tojudgeKeywordOptions:SearchOptions)
    func didTapCell()
    var numberOfCell:Int { get }
    func didSelectRowAt()
    func prefecture(row:Int)->Prefecture
    func facility(row:Int)->Facility
    func sport(row:Int)-> Sport
    func tag(row: Int)->Tag
    func moneyUnit(row:Int)->MoneyUnits
}
protocol SearchListOutputs:AnyObject {
    func reload()
}
protocol PresentarType {
    
}

final class SearchListPresentar:SearchListInputs,PresentarType {
    
    private var selectedCity = [String]()
    private var selectedTag = [String]()
    private var selectedInstion = [String]()
    private var selectedCompetion = [String]()
    private var selectedPrice = [String]()
    private var facilities = [Facility]()
    private var sports = [Sport]()
    private var tags = [Tag]()
    private var moneyUnit = [MoneyUnits]()
    private var prefectures = [Prefecture]()
    private weak var outputs:SearchListOutputs!
    private var model:FetchFacilityInputs!
    private var option:SearchOptions!
    private var sportsInput:FetchSportsInputs!
    private var tagsInput:FetchTagInputs!
    private var moneyInput:FetchMoneyInputs!
    private var prefectureInput:FetchPrefectureInputs!
    init(outputs:SearchListOutputs,model:FetchFacilityInputs,option:SearchOptions,sports:FetchSportsInputs,tags:FetchTagInputs,moneyUnit:FetchMoneyInputs,prefecture:FetchPrefectureInputs) {
        self.outputs = outputs
        self.model = model
        self.option = option
        self.sportsInput = sports
        self.tagsInput = tags
        self.moneyInput = moneyUnit
        self.prefectureInput = prefecture
    }
    var numberOfCell: Int {
        switch option {
        case .place:
            return prefectures.count
        case .institution:
            return facilities.count
        case .competition:
            return sports.count
        case .price:
            return moneyUnit.count
        case .tag:
            return tags.count
        case .none:
            return 0
        }
    }
    func didTapCell() {
        
    }
    func viewDidLoad(_ tojudgeKeywordOptions: SearchOptions) {
        switch tojudgeKeywordOptions {
        case .place:
            prefectureInput.fetchPrefecture { result in
                switch result {
                case .success(let prefecture):
                    self.prefectures = prefecture
                    self.outputs.reload()
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
                    self.outputs.reload()
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
    func didSelectRowAt() {
        
    }
    func facility(row: Int) -> Facility {
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
    
   
}
