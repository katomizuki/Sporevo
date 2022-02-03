import UIKit
import Alamofire
import RxSwift
import RxCocoa

protocol MainControllerDelegate: AnyObject {
    func handleMenuToggle(forMenuOptions menuOptions: MenuOptions?)
}
final class MainController: UIViewController {
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
    weak var delegate: MainControllerDelegate?
    private let firstVC = MapController()
    private lazy var secondVC = FacilityListController(viewModel: InstituationListViewModel(store: appStore, actionCreator: FacilityListActionCreator(repositry: FacilityRepositryImpl())))
    private var viewModel: MainViewModel
    private let disposeBag = DisposeBag()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        view.addSubview(scrollView)
        setupNav()
        viewModel.didLoad.accept(())
        bind()
    }
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        viewModel.willAppear.accept(())
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.frame.width * 2, height: 0)
        addChildVC()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.willDisAppear.accept(())
    }
    
    func bind() {
        viewModel.outputs.toDetail.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.toDetail()
        }.disposed(by: disposeBag)
        
        viewModel.outputs.segmentIndex.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.moveScoll(index: index)
        }).disposed(by: disposeBag)
        
        
    }
    
    private func moveScoll(index: Int) {
        if index == 0 {
            self.scrollView.setContentOffset(.zero, animated: true)
        } else {
            self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width, y: 0), animated: true)
        }
    }
    
    private func toDetail() {
        let controller = SearchListController(viewModel: SearchListViewModel(store: appStore))
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    private func addChildVC() {
        addChild(firstVC)
        addChild(secondVC)
        scrollView.addSubview(firstVC.view)
        scrollView.addSubview(secondVC.view)
        firstVC.view.frame = CGRect(x: 0,
                                    y: 0,
                                    width: view.frame.width,
                                    height: view.frame.height)
        secondVC.view.frame = CGRect(x: scrollView.frame.size.width,
                                     y: 0,
                                     width: view.frame.width,
                                     height: view.frame.height)
        firstVC.didMove(toParent: self)
        secondVC.didMove(toParent: self)
    }
    
    private func setupNav() {
        navigationController?.navigationBar.barTintColor = .systemMint
        let image = UIImage(systemName: "line.horizontal.3")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(didTapLeftBarButton))
        let searchImage = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: searchImage, style: .done, target: self, action: #selector(didTapSearchDetailButton))
        navigationItem.titleView = segmentController
        navigationController?.navigationBar.tintColor = .darkGray
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    // MARK: - Selector
    @objc private func didTapLeftBarButton() {
        print(#function)
        delegate?.handleMenuToggle(forMenuOptions: nil)
    }
    @objc private func didTapSearchDetailButton() {
        print(#function)
        viewModel.didTapDetailSearchButton()
    }
    @objc private func didChangeSegmentController(sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        viewModel.didTapSegment(index: selectedIndex)
    }
}

extension MainController:SearchListControllerDelegate {
    func facilitySearchController(_ controller: SearchListController) {
        controller.dismiss(animated: true, completion: nil)
        viewModel.dismiss(secondVC)
    }
}
