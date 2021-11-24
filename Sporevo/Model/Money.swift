import Foundation
import Alamofire
struct MoneyUnits:Codable {
    let id:Int
    let name:String
}
struct MoneyUnitsSelected:Codable {
    let id:Int
    let name:Int
}
protocol FetchMoneyInputs {
    func fetchMoney(completion: @escaping (Result<[MoneyUnits], Error>) -> Void)
    func fetchMoney(index:Int,completion: @escaping (Result<[MoneyUnitsSelected], Error>) -> Void)
}

struct FetchMoney:FetchMoneyInputs {
    func fetchMoney(completion: @escaping (Result<[MoneyUnits], Error>) -> Void) {
        let header:HTTPHeaders = ["Authorization":"Token LIcCke0gTSNAloR7ptYq"]
        let baseURL = "https://spo-revo.com/api/v1/price_use_units"
        AF.request(baseURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { response in
            guard let data = response.data else { return }
            do {
                let moneyUnits = try JSONDecoder().decode([MoneyUnits].self, from: data)
                completion(.success(moneyUnits))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchMoney(index:Int,completion: @escaping (Result<[MoneyUnitsSelected], Error>) -> Void) {
        let header:HTTPHeaders = ["Authorization":"Token LIcCke0gTSNAloR7ptYq"]
        let baseURL = "https://spo-revo.com/api/v1//price_ranges?price_use_unit_id=\(index)"
        AF.request(baseURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { response in
            guard let data = response.data else { return }
            do {
                let moneyUnitsSelected = try JSONDecoder().decode([MoneyUnitsSelected].self, from: data)
                completion(.success(moneyUnitsSelected))
            } catch {
                completion(.failure(error))
            }
        }
    }
    

}
