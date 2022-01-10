import Foundation
import Alamofire
import RealmSwift

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
    private let realm = try! Realm()
    func fetchPrefecture(completion: @escaping (Result<[Prefecture], Error>) -> Void) {
        let header:HTTPHeaders = ["Authorization":"Token LIcCke0gTSNAloR7ptYq"]
        let baseURL = "https://spo-revo.com/api/v1/prefectures"
        AF.request(baseURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { response in
            guard let data = response.data else { return }
            do {
                let prefecture = try JSONDecoder().decode([Prefecture].self, from: data)
                completion(.success(prefecture))
                prefecture.forEach {
                    let prefectureEntity = PrefectureEntity()
                    prefectureEntity.id = $0.id
                    prefectureEntity.name = $0.name
                    try! realm.write({
                        realm.add(prefectureEntity)
                    })
                }
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
                cities.forEach {
                    let cityEntity = CityEntity()
                    cityEntity.id = $0.id
                    cityEntity.name = $0.name
                    cityEntity.prefectureId = id
                    try! realm.write ({
                        realm.add(cityEntity)
                    })
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
}
