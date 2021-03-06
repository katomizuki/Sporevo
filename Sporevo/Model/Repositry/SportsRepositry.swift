//
//  FetchSportsRepositry.swift
//  Sporevo
//
//  Created by ミズキ on 2022/01/28.
//

import Foundation
import Alamofire
import RealmSwift

struct SportsRepositryImpl {
    private let realm = try! Realm()
    func saveSports() {
        let header:HTTPHeaders = ["Authorization":"Token LIcCke0gTSNAloR7ptYq"]
        let baseURL = "https://spo-revo.com/api/v1/sports_types"
            AF.request(baseURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { response in
                guard let data = response.data else { return }
                do {
                    let sports = try JSONDecoder().decode([Sport].self, from: data)
                    sports.forEach {
                        let sportEntity = SportEntity()
                        sportEntity.name = $0.name
                        sportEntity.id = $0.id
                        try! realm.write({
                            realm.add(sportEntity)
                        })
                    }
                } catch { print(error.localizedDescription) }
            }
    }
}
