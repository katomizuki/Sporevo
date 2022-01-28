
struct Facility:Codable,Equatable {
    let address:String?
    let id:Int?
    let name: String?
    let sub_name:String?
    let tags:[String]
    let sports_types:[String]
}
