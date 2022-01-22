import Foundation
import RealmSwift
protocol SearchListInputs {
    func viewDidLoad()
    func numberOfCell(section:Int)->Int
    func didSelectRowAt(indexPath:IndexPath)
    func saveUserDefaults()
    var sectionsCount: Int { get }
    func didTapSection(section: Int)
    func getMessage(indexPath:IndexPath)->String
    var citySections:[CitySection] { get set }
    var tags:[Tag] { get set }
    var sports:[Sport] { get set }
    var facilities:[FacilityType] { get set }
    var moneySections:[MoneySection] { get set }
    var selectedCity:[City] { get set }
    var selectedTag:[Tag] { get set }
    var selectedInstion:[FacilityType] { get set }
    var selectedCompetion:[Sport] { get set }
    var selectedPrice:[PriceUnits] { get set }
}
protocol SearchListOutputs:AnyObject {
    func reload()
    func reloadSections(section:Int)
}
final class SearchListPresentar:SearchListInputs {
    // MARK: - Properties
    var selectedCity = [City]()
    var selectedTag = [Tag]()
    var selectedInstion = [FacilityType]()
    var selectedCompetion = [Sport]()
    var selectedPrice = [PriceUnits]()
    var facilities = [FacilityType]()
    var sports = [Sport]()
    var tags = [Tag]()
    var citySections = [CitySection]()
    var moneySections = [MoneySection]()
    private weak var outputs:SearchListOutputs!
    private var option:SearchOptions!
    init(outputs:SearchListOutputs, option: SearchOptions) {
        self.outputs = outputs
        self.option = option
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
    
    func viewDidLoad() {
        switch option {
        case .place:
            DetailSearchActionCreator.fetchPrefecture()
        case .institution:
            DetailSearchActionCreator.fetchFacilityType()
        case .competition:
            DetailSearchActionCreator.fetchSport()
        case .price:
            DetailSearchActionCreator.fetchMoneySections()
        case .tag:
            DetailSearchActionCreator.fetchTag()
        case .none:
            break
        }
    }
    
    func didSelectRowAt(indexPath:IndexPath) {
        DetailSearchActionCreator.didSelectRowAt(option: option, indexPath: indexPath)
    }
    func saveUserDefaults() {
        DetailSearchActionCreator.saveUserDefaults(option: option)
    }
    
    func didTapSection(section: Int) {
        DetailSearchActionCreator.didTapSection(section: section, option: option)
        self.outputs.reloadSections(section: section)
    }
    
    func getMessage(indexPath: IndexPath) -> String {
        let row = indexPath.row
        let section = indexPath.section
        var message = String()
        switch option {
        case .institution: message = self.facilities[row].name
        case .competition: message = self.sports[row].name
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

