import Alamofire
import Foundation
import RealmSwift
struct Facilities :Codable {
    let facilities:[Facility]
}
struct Facility:Codable,Equatable {
    let address:String?
    let id:Int?
    let name: String?
    let sub_name:String?
    let tags:[String]
    let sports_types:[String]
}
struct FacilityDetail:Codable {
    var access:String?
    var address:String?
    var facility_type:String?
    var group_use_regist:String?
    var group_use_regist_text:String?
    var lat:Double?
    var lng:Double?
    var name:String?
    var booking_url:String?
    var business_hours:String?
    var holiday:String?
    var how_to_book:String?
    var hp:String?
    var informer:String?
    var memo:String?
    var phone_number:String?
    var price_info:String?
    var personal_use_regist:String?
    var personal_use_regist_text:String?
    var sub_name:String?
    var booking_types:[String]
    var equipment_types:[String]
    var parking_types:[String]
    var price_ranges:[String]
    var sports_types:[String]
    var tags:[String]
    var updated_at:String?
    var user_types:[String]
}

protocol FetchFacilityInputs {
    func fetchFacility(completion:@escaping(Result<Facilities,Error>) ->Void)
}
struct FetchFacility: FetchFacilityInputs {
    private let realm = try! Realm()
    func fetchFacility(completion: @escaping (Result<Facilities, Error>) -> Void) {
        let header:HTTPHeaders = ["Authorization":"Token LIcCke0gTSNAloR7ptYq"]
        let queri = makeCityQueri() + makeFacilityQueri() + makeTagQueri() + makePriceQueri() + makeSportQueri()
        //        \(queri)/size=10&page=1
        let baseURL = "https://spo-revo.com/api/v1/facilities?size=2000&page=1"
        AF.request(baseURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { response in
            guard let data = response.data else { return }
            do {
                let decodeData = try JSONDecoder().decode(Facilities.self, from: data)
                completion(.success(decodeData))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func saveFacility() {
        let header:HTTPHeaders = ["Authorization":"Token LIcCke0gTSNAloR7ptYq"]
        let baseURL = "https://spo-revo.com/api/v1/facilities?size=2000&page=1"
            AF.request(baseURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { response in
                guard let data = response.data else { return }
                do {
                    let decodeData = try JSONDecoder().decode(Facilities.self, from: data)
                    decodeData.facilities.forEach {
                        let facility = FacilityEntity()
                        facility.address = $0.address ?? ""
                        facility.id = $0.id ?? 0
                        facility.subName = $0.sub_name ?? ""
                        facility.name = $0.name ?? ""
                        $0.tags.forEach { tag in
                            let tagTitle = TagTitle()
                            tagTitle.title = tag
                            facility.tags.append(tagTitle)
                        }
                        $0.sports_types.forEach { typeName in
                            let sportType = SportsType()
                            sportType.name = typeName
                            facility.sportsType.append(sportType)
                        }
                        try! realm.write({
                            realm.add(facility)
                        })
                    }
                    FetchFacility().saveFacilityDetail()
                } catch { print(error.localizedDescription) }
            }
        }
    
    
    func fetchFacilityById(id:String,completion:@escaping(Result<FacilityDetail,Error>)->Void) {
        let header:HTTPHeaders = ["Authorization":"Token LIcCke0gTSNAloR7ptYq"]
        let baseURL = "https://spo-revo.com/api/v1/facilities/" + id
        AF.request(baseURL, method: .get, encoding: URLEncoding.default, headers: header).responseJSON { response in
            guard let data = response.data else { return }
            do {
                let decodedData = try JSONDecoder().decode(FacilityDetail.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
    }
    func saveFacilityDetail() {
        let allFacility = realm.objects(FacilityEntity.self).map(
            { Facility(address: $0.address, id: $0.id, name: $0.name, sub_name: $0.subName, tags: $0.tags.map({ $0.title }), sports_types: $0.sportsType.map( {$0.name} )) }
        )
        let group = DispatchGroup()
        allFacility.forEach {
            group.enter()
            self.fetchFacilityById(id: String($0.id!)) { result in
                defer { group.leave() }
                switch result {
                case .success(let detail):
                    
                    try! realm.write({
                        let entity = FacilityDetailEntity()
                        entity.subName = detail.sub_name ?? ""
                        entity.address = detail.address ?? ""
                        entity.name = detail.name ?? ""
                        entity.access = detail.access ?? ""
                        entity.hp = detail.hp ?? ""
                        entity.bookingUrl = detail.booking_url ?? ""
                        entity.businessHours = detail.business_hours ?? ""
                        entity.lat = detail.lat ?? 0.0
                        entity.lng = detail.lng ?? 0.0
                        entity.facilityType = detail.facility_type ?? ""
                        entity.groupUseRegist = detail.group_use_regist ?? ""
                        entity.holiday = detail.holiday ?? ""
                        entity.howToBook = detail.how_to_book ?? ""
                        entity.personalUseRegist = detail.personal_use_regist ?? ""
                        entity.personalUseRegistText = detail.personal_use_regist_text ?? ""
                        entity.informer = detail.informer ?? ""
                        entity.memo = detail.memo ?? ""
                        entity.priceInfo = detail.price_info ?? ""
                        entity.phoneNumber = detail.phone_number ?? ""
                        entity.updateAt = detail.updated_at ?? ""
                        detail.booking_types.forEach {
                            let bookingType = BookingType()
                            bookingType.title = $0
                            entity.bookingTypes.append(bookingType)
                        }
                        detail.equipment_types.forEach {
                            let equipmentType = EquipmentType()
                            equipmentType.title = $0
                            entity.equipmentTypes.append(equipmentType)
                        }
                        detail.user_types.forEach {
                            let userType = UserType()
                            userType.title = $0
                            entity.user_types.append(userType)
                        }
                        detail.sports_types.forEach {
                            let sportType = SportsType()
                            sportType.name = $0
                            entity.sportsTypes.append(sportType)
                        }
                        detail.tags.forEach {
                            let tag = TagTitle()
                            tag.title = $0
                            entity.tags.append(tag)
                        }
                        detail.parking_types.forEach {
                            let parkingType = ParkingTypes()
                            parkingType.title = $0
                            entity.parkingTypes.append(parkingType)
                        }
                        detail.price_ranges.forEach {
                            let priceRange = PriceRanges()
                            priceRange.title = $0
                            entity.priceRanges.append(priceRange)
                        }
                        realm.add(entity)
                    })
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    
    func makeCityQueri()->String {
        var q = String()
        let city:[City] = UserDefaultRepositry.shared.loadFromUserDefaults(key:"city")
        city.forEach { ele in
            let id = ele.id
            q += "q[city_id_eq_any][]=\(id)&"
        }
        return q
    }
    func makeFacilityQueri()->String {
        var q = String()
        let facility:[FacilityType] = UserDefaultRepositry.shared.loadFromUserDefaults(key: "facility")
        facility.forEach { ele in
            let id = ele.id
            q += "q[facility_type_id_eq_any][]=\(id)&"
        }
        return q
    }
    func makeTagQueri()->String {
        var q = String()
        let tag:[Tag] = UserDefaultRepositry.shared.loadFromUserDefaults(key: "tag")
        tag.forEach { ele in
            let id = ele.id
            q += "q[tags_id_eq_any][]=\(id)&"
        }
        return q
    }
    func makePriceQueri()->String {
        var q = String()
        let price:[PriceUnits] = UserDefaultRepositry.shared.loadFromUserDefaults(key: "priceUnits")
        price.forEach { ele in
            let id = ele.id
            q += "q[price_ranges_id_eq_any][]=\(id)&"
        }
        return q
    }
    func makeSportQueri()->String {
        var q = String()
        let sports:[Sport] = UserDefaultRepositry.shared.loadFromUserDefaults(key: "sport")
        sports.forEach { ele in
            let id = ele.id
            q += "q[sports_types_id_eq_any][]=\(id)&"
        }
        return q
    }
}

