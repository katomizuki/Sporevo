import Foundation
import UIKit
import MapKit
import RealmSwift

class SearchMapController:UIViewController {
    
    private lazy var navBar:UINavigationBar = {
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0,
                                                   width: view.frame.width, height: 30))
        navBar.barTintColor = .yellow
        return navBar
    }()
    let mapView = MKMapView()
    private var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        setupPin()
    }
    private func setupPin() {
        let realm = try! Realm()
        let allDetail: [FacilityDetail] = realm.objects(FacilityDetailEntity.self).map({
            FacilityDetail(access: $0.access, address: $0.address, facility_type: $0.facilityType, group_use_regist: $0.groupUseRegist, group_use_regist_text: $0.personalUseRegistText, lat: $0.lat, lng: $0.lng, name: $0.name, booking_url: $0.bookingUrl, business_hours: $0.businessHours, holiday: $0.holiday, how_to_book: $0.howToBook, hp: $0.hp, informer: $0.informer, memo: $0.memo, phone_number: $0.phoneNumber, price_info: $0.priceInfo, personal_use_regist: $0.personalUseRegist, personal_use_regist_text: $0.personalUseRegistText, sub_name: $0.subName, booking_types: [], equipment_types: [], parking_types: [], price_ranges: [], sports_types: [], tags: [], updated_at:"", user_types: [])
        })
        
        allDetail.forEach {
            let coorinate = CLLocationCoordinate2DMake($0.lat ?? 0.0, $0.lng ?? 0.0)
            let pin = MKPointAnnotation()
            pin.title = $0.name
            pin.subtitle = $0.sub_name ?? ""
            pin.coordinate = coorinate
            mapView.addAnnotation(pin)
        }
        
        
    }
    private func setupUI() {
        navigationController?.navigationBar.barTintColor = .systemMint
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.6809591,139.7673068)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        view.addSubview(mapView)
        mapView.anchor(top:view.topAnchor,bottom: view.bottomAnchor,
                       left: view.leftAnchor,right: view.rightAnchor)
    }
}

extension SearchMapController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways,.authorizedWhenInUse:
            manager.distanceFilter = 10
            manager.startUpdatingLocation()
        case .denied,.restricted:
            manager.requestWhenInUseAuthorization()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
}
