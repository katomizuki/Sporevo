import Foundation
import UIKit
import MapKit
protocol SearchMapControllerDelegate:AnyObject {
    func didTapSegmentController(index:Int)
}
class SearchMapController:UIViewController {
   
    private lazy var navBar:UINavigationBar = {
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0,
                                                   width: view.frame.width, height: 30))
        navBar.barTintColor = .yellow
        return navBar
    }()
    let mapView = MKMapView()
    weak var delegate:SearchMapControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNabBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    private func setupNabBar() {
        print(#function)
        navigationController?.navigationBar.barTintColor = .darkGray
        view.addSubview(mapView)
        mapView.anchor(top:view.topAnchor,bottom: view.bottomAnchor,
                       left: view.leftAnchor,right: view.rightAnchor)
    }
}
