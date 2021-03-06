//
//  FetchFacilityTypeRepositry.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/28.
//
import Foundation
import Alamofire
import RealmSwift

struct FacilityTypeRepositryImpl {
    
    private let realm = try! Realm()
    
    func saveFacility() {
        let header:HTTPHeaders = ["Authorization":"Token LIcCke0gTSNAloR7ptYq"]
        let baseURL = "https://spo-revo.com/api/v1/facility_types"
            AF.request(baseURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { response in
                guard let data = response.data else { return }
                do {
                    let facility = try JSONDecoder().decode([FacilityType].self, from: data)
                    
                    facility.forEach {
                        let type = FacilityTypeEntity()
                        type.id = $0.id
                        type.name = $0.name
                        try! realm.write({
                            realm.add(type)
                        })
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
    }
}
