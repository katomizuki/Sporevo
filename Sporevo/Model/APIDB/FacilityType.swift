
import Foundation
import Alamofire
struct FacilityType:Codable,Equatable {
    var id:Int
    var name:String
}
protocol FetchFacilityTypeInputs {
    func fetchFacility(completion:@escaping(Result<[FacilityType],Error>) ->Void) 
}
struct FetchFacilityType:FetchFacilityTypeInputs {
    func fetchFacility(completion:@escaping(Result<[FacilityType],Error>) ->Void) {
                let header:HTTPHeaders = ["Authorization":"Token LIcCke0gTSNAloR7ptYq"]
                let baseURL = "https://spo-revo.com/api/v1/facility_types"
                AF.request(baseURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { response in
                    guard let data = response.data else { return }
                    do {
                        let facility = try JSONDecoder().decode([FacilityType].self, from: data)
                        completion(.success(facility))
                    } catch {
                        completion(.failure(error))
                    }
                }
    }
}
