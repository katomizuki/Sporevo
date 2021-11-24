import Foundation
import Alamofire
struct Prefecture:Codable {
    let name:String
    let id:Int
}
protocol FetchPrefectureInputs {
    func fetchPrefecture(completion: @escaping (Result<[Prefecture], Error>) -> Void)
}

struct FetchPrefecture:FetchPrefectureInputs {
    
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
}
