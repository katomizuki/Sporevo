
import Foundation
import UIKit
protocol FacilitySearchInputs {
    func loadUserDefaults()
    var selectedTag:[Tag] { get }
    var selectedSports:[Sport] { get }
    var selectedFacility:[Facility] { get }
    func getSelectedMessage(row:Int)->String
    func deleteUserDefaults()
}
protocol FacilitySearchOutputs:AnyObject {
    
}
final class FacilitySearchPresentar:FacilitySearchInputs {
    // MARK: - Properties
    var selectedTag = [Tag]()
    var selectedSports = [Sport]()
    var selectedFacility = [Facility]()
    private weak var outputs:FacilitySearchOutputs?
    // MARK: - Initialize
    init(outputs:FacilitySearchOutputs) {
        self.outputs = outputs
    }
    func loadUserDefaults() {
        selectedTag = UserDefaultRepositry.shared.loadFromUserDefaults(key: "tag")
        selectedFacility = UserDefaultRepositry.shared.loadFromUserDefaults(key: "facility")
        selectedSports = UserDefaultRepositry.shared.loadFromUserDefaults(key: "sport")
        print(selectedTag)
    }
    func getSelectedMessage(row: Int) -> String {
        var message = String()
        switch row {
        case 1:
            if selectedFacility.count == 0 { return "" }
            selectedFacility.forEach { message += "　\($0.name)"}
        case 2:
            if selectedSports.count == 0 { return "" }
            selectedSports.forEach { message += "　\($0.name)" }
        case 3:
            if selectedTag.count == 0 { return "" }
            selectedTag.forEach { message += "　\($0.name)" }
        default:return ""
        }
        return message
    }
    func deleteUserDefaults() {
        UserDefaultRepositry.shared.deleteFromUserDefaults(key: "tag")
        UserDefaultRepositry.shared.deleteFromUserDefaults(key: "sport")
        UserDefaultRepositry.shared.deleteFromUserDefaults(key: "facility")
    }
    
    
}
