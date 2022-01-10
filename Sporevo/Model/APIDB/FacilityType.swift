
import Foundation
import Alamofire
import RealmSwift
struct FacilityType:Codable,Equatable {
    var id:Int
    var name:String
}
protocol FetchFacilityTypeInputs {
    func fetchFacility(completion:@escaping(Result<[FacilityType],Error>) ->Void) 
}
struct FetchFacilityType:FetchFacilityTypeInputs {
    private let realm = try! Realm()
    func fetchFacility(completion:@escaping(Result<[FacilityType],Error>) ->Void) {
                let header:HTTPHeaders = ["Authorization":"Token LIcCke0gTSNAloR7ptYq"]
                let baseURL = "https://spo-revo.com/api/v1/facility_types"
                AF.request(baseURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { response in
                    guard let data = response.data else { return }
                    do {
                        let facility = try JSONDecoder().decode([FacilityType].self, from: data)
                        completion(.success(facility))
                        facility.forEach { 
                            let type = FacilityTypeEntity()
                            type.id = $0.id
                            type.name = $0.name
                            try! realm.write({
                                realm.add(type)
                            })
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
    }
}
