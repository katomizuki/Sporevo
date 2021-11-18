import Foundation
import UIKit
protocol SearchMapControllerDelegate:AnyObject {
    func didTapSegmentController(index:Int)
}
class SearchMapController:UIViewController {
    private lazy var segmentController :UISegmentedControl = {
        let segment = UISegmentedControl(items: ["地図で探す","一覧"])
        segment.selectedSegmentIndex = 1
        segment.addTarget(self, action: #selector(didChangeSegmentController), for: .valueChanged)
        return segment
    }()
    private lazy var navBar:UINavigationBar = {
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0,
                                                   width: view.frame.width, height: 30))
        navBar.barTintColor = .yellow
        return navBar
    }()
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
        view.backgroundColor = .darkGray
        navigationItem.titleView = segmentController
    }
    @objc private func didChangeSegmentController(sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        print(#function)
        self.delegate?.didTapSegmentController(index: selectedIndex)
    }
}
