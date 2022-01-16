import Foundation
import Alamofire
import RealmSwift

struct MoneyUnits:Codable,Equatable {
    let id:Int
    let name:String
}
struct PriceUnits:Codable,Equatable {
    let id:Int
    let name:String
}


struct FetchMoney {
    private let realm = try! Realm()
 
    func saveMoney() {
        let header:HTTPHeaders = ["Authorization":"Token LIcCke0gTSNAloR7ptYq"]
        let baseURL = "https://spo-revo.com/api/v1/price_use_units"
            AF.request(baseURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { response in
                guard let data = response.data else { return }
                do {
                    let moneyUnits = try JSONDecoder().decode([MoneyUnits].self, from: data)
                    moneyUnits.forEach {
                        let moneyUnitsEntity = MoneyUnitsEntity()
                        moneyUnitsEntity.id = $0.id
                        moneyUnitsEntity.name = $0.name
                        self.savePrice(index: $0.id)
                        try! realm.write({
                            realm.add(moneyUnitsEntity)
                        })
                    }
                } catch { print(error.localizedDescription) }
            }
    }
    
    func savePrice(index:Int) {
        let header:HTTPHeaders = ["Authorization":"Token LIcCke0gTSNAloR7ptYq"]
        let baseURL = "https://spo-revo.com/api/v1//price_ranges?price_use_unit_id=\(index)"
            AF.request(baseURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { response in
                guard let data = response.data else { return }
                do {
                    let moneyUnitsSelected = try JSONDecoder().decode([PriceUnits].self, from: data)
                    moneyUnitsSelected.forEach {
                        let priceUnitsEntity = PriceUnitsEntity()
                        priceUnitsEntity.id = $0.id
                        priceUnitsEntity.name = $0.name
                        priceUnitsEntity.moneyUnitId = index
                        try! realm.write({
                            realm.add(priceUnitsEntity)
                        })
                    }
                } catch { print(error.localizedDescription) }
            }
    }

}
