
import Foundation
import Alamofire
struct Sport:Decodable,Equatable {
    let name:String
    let id:Int
}
protocol FetchSportsInputs {
    func fetchSports(completion:@escaping(Result<[Sport],Error>) ->Void)
}

struct FetchSports:FetchSportsInputs {
    func fetchSports(completion:@escaping(Result<[Sport],Error>) ->Void) {
                print(#function)
                let header:HTTPHeaders = ["Authorization":"Token LIcCke0gTSNAloR7ptYq"]
                let baseURL = "https://spo-revo.com/api/v1/sports_types"
                AF.request(baseURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { response in
                    guard let data = response.data else { return }
                    do {
                        let sports = try JSONDecoder().decode([Sport].self, from: data)
                        completion(.success(sports))
                    } catch {
                        completion(.failure(error))
                    }
                }
    }
}
