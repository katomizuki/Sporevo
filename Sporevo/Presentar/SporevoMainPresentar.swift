
import Foundation
protocol SporevoMainInputs {
    func viewdidLoad()
    func didTapDetailSearchButton()
    func didTapSegment(index:Int)
    func dismiss()
}
protocol SporevoMainOutputs:AnyObject {
    func loadData()
    func detailSearchController()
    func changeSegment(index:Int)
}
final class SporevoMainPresentar:SporevoMainInputs {
    
    private weak var outputs:SporevoMainOutputs!
    private var api:FetchFacilityInputs!
    private var facility:Facilities?
    init(outputs:SporevoMainOutputs,api:FetchFacilityInputs) {
        self.outputs = outputs
        self.api = api
    }
    
    func viewdidLoad() {
        self.outputs.loadData()
    }
    
    func didTapDetailSearchButton() {
        outputs.detailSearchController()
    }
    func didTapSegment(index:Int) {
        self.outputs.changeSegment(index: index)
    }
    func dismiss() {
        api.fetchFacility { result in
            switch result {
            case .success(let facility):
                self.facility = facility
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
