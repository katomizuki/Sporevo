
import Foundation
protocol SporevoMainInputs {
    func viewdidLoad()
    func didTapDetailSearchButton()
    func didTapSegment(index:Int)
    func dismiss(_ controller: InstitutionListController)
}
protocol SporevoMainOutputs:AnyObject {
    func loadData()
    func detailSearchController()
    func changeSegment(index:Int)
    func showError(_ error: Error)
}
final class SporevoMainPresentar:SporevoMainInputs {
    
    private weak var outputs:SporevoMainOutputs!
    private var api:FetchFacilityInputs!
    private var facility:Facilities?
    
    init(outputs:SporevoMainOutputs,api: FetchFacilityInputs) {
        self.outputs = outputs
        self.api = api
    }
    
    func viewdidLoad() {
        self.outputs.loadData()
        if UserDefaults.standard.object(forKey: "isLocalDB") == nil {
            FetchFacilityType().saveFacility()
            FetchSports().saveSports()
            FetchMoney().saveMoney()
            FetchTags().saveTags()
            FetchPrefecture().savePrefecture()
            FetchFacility().saveFacility()
        }
        UserDefaults.standard.set(true, forKey: "isLocalDB")
    }
    
    func didTapDetailSearchButton() {
        outputs.detailSearchController()
    }
    func didTapSegment(index:Int) {
        self.outputs.changeSegment(index: index)
    }
    func dismiss(_ controller:InstitutionListController) {
        api.fetchFacility { result in
            switch result {
            case .success(let facility):
                self.facility = facility
                controller.facilities = facility
            case .failure(let error):
                self.outputs.showError(error)
            }
        }
    }
    
}
