import UIKit
import Alamofire
protocol SporevoMainControllerDelegate: AnyObject {
    func handleMenuToggle(forMenuOptions menuOptions: MenuOptions?)
}
class SporevoMainController: UIViewController {
    // MARK: - Properties
    
    private lazy var segmentController :UISegmentedControl = {
        let segment = UISegmentedControl(items: ["地図で探す","一覧"])
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(didChangeSegmentController), for: .valueChanged)
        return segment
    }()
    private let scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    weak var delegate: SporevoMainControllerDelegate?
    private let firstVC = SearchMapController()
    private let secondVC = ListController()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        scrollView.contentSize = CGSize(width: view.frame.size.width * 2, height: 0)
        view.addSubview(scrollView)
        setupNav()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //ここで完全にViewのframeが決定されるから
        scrollView.frame = view.bounds
        addChildVC()
    }
    
    private func addChildVC() {
        addChild(firstVC)
        addChild(secondVC)
        scrollView.addSubview(firstVC.view)
        scrollView.addSubview(secondVC.view)
        firstVC.view.frame = CGRect(x: 0,
                                    y: 0,
                                    width: scrollView.frame.width,
                                    height: scrollView.frame.height)
        secondVC.view.frame = CGRect(x: scrollView.frame.size.width, y: 0,
                                     width: scrollView.frame.size.width,
                                     height: scrollView.frame.size.height)
        firstVC.didMove(toParent: self)
        secondVC.didMove(toParent: self)
    }
    private func setupNav() {
        navigationController?.navigationBar.barTintColor = .darkGray
              let image = UIImage(systemName: "line.horizontal.3")?.withRenderingMode(.alwaysOriginal)
              navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(didTapLeftBarButton))
        let searchImage = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: searchImage, style: .done, target: self, action: #selector(didTapSearchDetailButton))
        navigationItem.titleView = segmentController
    }
    
    @objc private func didTapLeftBarButton() {
        print(#function)
        delegate?.handleMenuToggle(forMenuOptions: nil)
    }
    @objc private func didTapSearchDetailButton() {
        print(#function)
        let controller = SearchDetailController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    @objc private func didChangeSegmentController(sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        if selectedIndex == 0 {
            scrollView.setContentOffset(.zero, animated: true)
        } else {
            scrollView.setContentOffset(CGPoint(x: view.frame.size.width, y: 0), animated: true)
        }
    }
}

