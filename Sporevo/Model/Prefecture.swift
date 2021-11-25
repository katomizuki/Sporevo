import Foundation
import Alamofire
struct Prefecture:Codable,Equatable {
    let name:String
    let id:Int
}
struct City:Codable,Equatable {
    let id:Int
    let name:String
}
protocol FetchPrefectureInputs {
    func fetchPrefecture(completion: @escaping (Result<[Prefecture], Error>) -> Void)
}
protocol FetchCityInputs {
    func fetchCities(id:Int,completion: @escaping (Result<[City], Error>) -> Void)
}
struct FetchPrefecture:FetchPrefectureInputs,FetchCityInputs {
    
    func fetchPrefecture(completion: @escaping (Result<[Prefecture], Error>) -> Void) {
        let header:HTTPHeaders = ["Authorization":"Token LIcCke0gTSNAloR7ptYq"]
        let baseURL = "https://spo-revo.com/api/v1/prefectures"
        AF.request(baseURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { response in
            guard let data = response.data else { return }
            do {
                let prefecture = try JSONDecoder().decode([Prefecture].self, from: data)
                completion(.success(prefecture))
            } catch {
                completion(.failure(error))
            }
        }
    }
    func fetchCities(id:Int,completion: @escaping (Result<[City], Error>) -> Void) {
        let header:HTTPHeaders = ["Authorization":"Token LIcCke0gTSNAloR7ptYq"]
        let baseURL = "https://spo-revo.com/api/v1/cities?prefecture_id=\(id)"
        AF.request(baseURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { response in
            guard let data = response.data else { return }
            do {
                let cities = try JSONDecoder().decode([City].self, from: data)
                completion(.success(cities))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
}
