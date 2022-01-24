import Foundation

protocol InstituationPresentarInputs {
    func viewDidLoad()
    var numberOfCells:Int { get }
    func facility(row:Int)->Facility
    func searchFacilies(facilities:Facilities)
}
protocol InstituationPresentarOutputs:AnyObject {
    func reload()
    func showError(_ error: Error)
}

final class InstituationPresentar:InstituationPresentarInputs {
    private weak var outputs:InstituationPresentarOutputs?
    var facilities:Facilities?
    var numberOfCells: Int {
        return facilities?.facilities.count ?? 0
    }
    init(outputs: InstituationPresentarOutputs) {
        self.outputs = outputs
    }
    func viewDidLoad() {
        FetchFacility().fetchFacility { result in
            switch result {
            case .success(let facilities):
                self.facilities = facilities
                self.outputs?.reload()
            case .failure(let error):
                self.outputs?.showError(error)
            }
        }
    }
    func facility(row: Int) -> Facility {
        guard let facilities = facilities else {
            fatalError()
        }
        return facilities.facilities[row]
    }
    func searchFacilies(facilities: Facilities) {
        self.facilities = facilities
        self.outputs?.reload()
    }
    func fetchDetailFacilities(id:String) {
        FetchFacility().fetchFacilityById(id: id) { result in
            
        }
    }
}
