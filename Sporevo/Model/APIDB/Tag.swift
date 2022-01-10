import Alamofire
import Foundation
import RealmSwift

struct Tag:Codable,Equatable {
    let id:Int
    let name:String
}


struct FetchTags {
    private let realm = try! Realm()
    func saveTags() {
        let header:HTTPHeaders = ["Authorization":"Token LIcCke0gTSNAloR7ptYq"]
        let baseURL = "https://spo-revo.com/api/v1/tags"
        AF.request(baseURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { response in
            guard let data = response.data else { return }
            do {
                let tags = try JSONDecoder().decode([Tag].self, from: data)
                tags.forEach {
                    let tagEntity = TagEntity()
                    tagEntity.id = $0.id
                    tagEntity.name = $0.name
                    try! realm.write({
                        realm.add(tagEntity)
                    })
                }
            } catch {
            }
        }
    }
}
