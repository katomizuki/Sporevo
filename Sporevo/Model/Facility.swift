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
struct FacilityDetail:Codable {
    var access:String?
    var address:String?
    var facility_type:String?
    var group_use_regist:String?
    var group_use_regist_text:String?
    var lat:Double?
    var lng:Double?
    var name:String?
    var booking_url:String?
    var business_hours:String?
    var holiday:String?
    var how_to_book:String?
    var hp:String?
    var informer:String?
    var memo:String?
    var phone_number:String?
    var price_info:String?
    var personal_use_regist:String?
    var personal_use_regist_text:String?
    var sub_name:String?
    var booking_types:[String]
    var equipment_types:[String]
    var parking_types:[String]
    var price_ranges:[String]
    var sports_types:[String]
    var tags:[String]
    var updated_at:String?
    var user_types:[String]
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
    func fetchFacilityById(id:String,completion:@escaping(Result<FacilityDetail,Error>)->Void) {
        let header:HTTPHeaders = ["Authorization":"Token LIcCke0gTSNAloR7ptYq"]
        let baseURL = "https://spo-revo.com/api/v1/facilities/" + id
        AF.request(baseURL, method: .get, encoding: URLEncoding.default, headers: header).responseJSON { response in
            guard let data = response.data else { return }
            do {
                let decodedData = try JSONDecoder().decode(FacilityDetail.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
