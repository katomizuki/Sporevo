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

struct FetchPrefecture {
    private let realm = try! Realm()
    
    func savePrefecture() {
        let header:HTTPHeaders = ["Authorization":"Token LIcCke0gTSNAloR7ptYq"]
        let baseURL = "https://spo-revo.com/api/v1/prefectures"
            AF.request(baseURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { response in
                guard let data = response.data else { return }
                do {
                    let prefecture = try JSONDecoder().decode([Prefecture].self, from: data)
                    prefecture.forEach {
                        let prefectureEntity = PrefectureEntity()
                        prefectureEntity.id = $0.id
                        prefectureEntity.name = $0.name
                        self.saveCities(id: $0.id)
                        try! realm.write({
                            realm.add(prefectureEntity)
                        })
                    }
                } catch {
                    print(error.localizedDescription)
            }
        }
    }
    
    func saveCities(id:Int) {
        let header:HTTPHeaders = ["Authorization":"Token LIcCke0gTSNAloR7ptYq"]
        let baseURL = "https://spo-revo.com/api/v1/cities?prefecture_id=\(id)"
            AF.request(baseURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { response in
                guard let data = response.data else { return }
                do {
                    let cities = try JSONDecoder().decode([City].self, from: data)
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
                    print(error.localizedDescription)
                }
            }
        }
}
