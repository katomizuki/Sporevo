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
}
protocol SearchListOutputs:AnyObject {
    func reload()
}

final class SearchListPresentar:SearchListInputs {
    
    private var selectedCity = [String]()
    private var selectedTag = [String]()
    private var selectedInstion = [String]()
    private var selectedCompetion = [String]()
    private var selectedPrice = [String]()
    private var facilities = [Facility]()
    private var sports = [Sport]()
    private weak var outputs:SearchListOutputs!
    private var model:FetchFacilityInputs!
    private var option:SearchOptions!
    private var sportsInput:FetchSportsInputs!
    init(outputs:SearchListOutputs,model:FetchFacilityInputs,option:SearchOptions,sports:FetchSportsInputs) {
        self.outputs = outputs
        self.model = model
        self.option = option
        self.sportsInput = sports
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
            return 0
        case .tag:
            return 0
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
            print("p")
        case .tag:
            print("t")
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
    
   
}
