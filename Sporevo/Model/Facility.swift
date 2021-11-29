import Alamofire
import Foundation

struct Facilities :Codable {
    let facilities:[Facility]
}
struct Facility:Codable,Equatable {
    let address:String
    let id:Int
    let name:String
    let sub_name:String
    let tags:[String]
    let sports_types:[String]
}

protocol FetchFacilityInputs {
    func fetchFacility(completion:@escaping(Result<Facilities,Error>) ->Void)
}
struct FetchFacility: FetchFacilityInputs {
    func fetchFacility(completion: @escaping (Result<Facilities, Error>) -> Void) {
        let header:HTTPHeaders = ["Authorization":"Token LIcCke0gTSNAloR7ptYq"]
        let baseURL = "https://spo-revo.com/api/v1/facilities?q=q&size=10&page=1"
        AF.request(baseURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { response in
            guard let data = response.data else { return }
            do {
                let decodeData = try JSONDecoder().decode(Facilities.self, from: data)
                completion(.success(decodeData))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
