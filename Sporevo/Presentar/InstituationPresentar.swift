import Foundation

protocol InstituationPresentarInputs {
    func viewDidLoad()
    var numberOfCells:Int { get }
    func facility(row:Int)->Facility
    func searchFacilies(facilities:Facilities)
}
protocol InstituationPresentarOutputs:AnyObject {
    func reload()
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
                print(error)
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
}
