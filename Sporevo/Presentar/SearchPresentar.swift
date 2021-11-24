import Foundation
struct Model<T> {
    
}
protocol SearchListInputs {
    func viewDidLoad(_ tojudgeKeywordOptions:SearchOptions)
    func didTapCell()
    var numberOfCell:Int { get }
    func didSelectRowAt()
//    func place(row:Int)->Int
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
    private weak var outputs:SearchListOutputs!
    private var model:FetchFacilityInputs!
    private var option:SearchOptions!
    private var sportsInput:FetchSportsInputs!
    private var tagsInput:FetchTagInputs!
    private var moneyInput:FetchMoneyInputs!
    init(outputs:SearchListOutputs,model:FetchFacilityInputs,option:SearchOptions,sports:FetchSportsInputs,tags:FetchTagInputs,moneyUnit:FetchMoneyInputs) {
        self.outputs = outputs
        self.model = model
        self.option = option
        self.sportsInput = sports
        self.tagsInput = tags
        self.moneyInput = moneyUnit
    }
    var numberOfCell: Int {
        switch option {
        case .place:
           return 0
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
            print("s")
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
    
   
}
