import Foundation
import UIKit

protocol FacilitySearchInputs {
    func loadUserDefaults()
    var selectedTag: [Tag] { get }
    var selectedSports: [Sport] { get }
    var selectedFacility: [FacilityType] { get }
    func getSelectedMessage(row: Int) -> String
    func deleteUserDefaults()
    func reload()
}

protocol FacilitySearchOutputs:AnyObject {
    func showError(_ error: Error)
    func reload()
}

final class FacilitySearchPresentar:FacilitySearchInputs {
    // MARK: - Properties
    var selectedTag = [Tag]()
    var selectedSports = [Sport]()
    var selectedFacility = [FacilityType]()
    var selectedPriceUnits = [PriceUnits]()
    var selectedCity = [City]()
    private weak var outputs:FacilitySearchOutputs?
    // MARK: - Initialize
    init(outputs:FacilitySearchOutputs) {
        self.outputs = outputs
    }
    
    func loadUserDefaults() {
        SearchListActionCreator.loadUserDefaults()
    }
    
    func reload() {
        self.outputs?.reload()
    }
    
    func getSelectedMessage(row: Int) -> String {
        var message = String()
        switch row {
        case 0: if selectedCity.count == 0 { return "" }
            selectedCity.forEach{ message += "　\($0.name)"}
        case 1:
            if selectedFacility.count == 0 { return "" }
            selectedFacility.forEach { message += "　\($0.name)"}
        case 2:
            if selectedSports.count == 0 { return "" }
            selectedSports.forEach { message += "　\($0.name)" }
        case 3:
            if selectedPriceUnits.count == 0 { return "" }
            selectedPriceUnits.forEach{ message += "  \($0.name)" }
        case 4:
            if selectedTag.count == 0 { return "" }
            selectedTag.forEach { message += "　\($0.name)" }
        default:return ""
        }
        return message
    }
    
    func deleteUserDefaults() {
        SearchListActionCreator.deleteUserDefaults()
    }
}
