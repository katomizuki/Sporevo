
import Foundation
import Alamofire
struct Facility:Codable {
    var id:Int
    var name:String
}
protocol FetchFacilityInputs {
    func fetchFacility(completion:@escaping(Result<[Facility],Error>) ->Void) 
}
struct FetchFacility:FetchFacilityInputs {
    func fetchFacility(completion:@escaping(Result<[Facility],Error>) ->Void) {
                print(#function)
                let header:HTTPHeaders = ["Authorization":"Token LIcCke0gTSNAloR7ptYq"]
                let baseURL = "https://spo-revo.com/api/v1/facility_types"
                AF.request(baseURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { response in
                    guard let data = response.data else { return }
                    do {
                        let facility = try JSONDecoder().decode([Facility].self, from: data)
                        completion(.success(facility))
                    } catch {
                        completion(.failure(error))
                    }
                }
    }
}
