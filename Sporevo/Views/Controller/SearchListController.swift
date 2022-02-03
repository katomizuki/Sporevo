import Foundation
import UIKit
import ReSwift
import RxSwift

protocol SearchListControllerDelegate:AnyObject {
    func facilitySearchController(_ controller:SearchListController)
}

final class SearchListController:UIViewController {
    // MARK: - Properties
    private var tableView:UITableView = UITableView(frame: .zero, style: .insetGrouped)
    weak var delegate:SearchListControllerDelegate?
    private lazy var searchButton:UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        button.setTitle("検索", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemMint
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        return button
    }()
    private let disposeBag = DisposeBag()
    private let viewModel: SearchListViewModel
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.willAppear.accept(())
        setupUI()
        viewModel.deleteUserDefaults()
        bind()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.willDisAppear.accept(())
    }
    init(viewModel: SearchListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    private func setupUI() {
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.id)
        view.addSubview(tableView)
        tableView.anchor(top:view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingRight: 20,
                         paddingLeft: 20)
        tableView.rowHeight = 60
        tableView.isScrollEnabled = false
        view.addSubview(searchButton)
        searchButton.anchor(top:tableView.bottomAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            paddingTop: 20,paddingBottom: 20,
                            centerX: view.centerXAnchor,
                            width: 60,
                            height: 40)
        let leftButton = UIBarButtonItem(title: "もどる", style: .done, target: self, action: #selector(didTapDismissButton))
        navigationItem.leftBarButtonItem = leftButton
        leftButton.tintColor = .systemMint
    }
    
    @objc private func didTapDismissButton() {
        viewModel.deleteUserDefaults()
        dismiss(animated: true, completion: nil)
    }
    
    func bind() {
        viewModel.outputs.reload.subscribe { [weak self] _ in
            self?.tableView.reloadData()
        }.disposed(by: disposeBag)
    }
}
// MARK: - SearchCellDelegate
extension SearchListController:SeachCellDelegate {
    func searchCell(_ cell: SearchCell) {
        print(#function)
        guard let options = SearchOptions(rawValue: tableView.indexPath(for: cell)?.section ?? 0) else { return }
        pushActions(options: options)
    }
    @objc private func didTapSearchButton() {
        self.delegate?.facilitySearchController(self)
    }
}
// MARK: - UITableViewDataSource
extension SearchListController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SearchOptions.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.id, for: indexPath) as? SearchCell else { fatalError("can't make SeachCell Error") }
        cell.delegate = self
        let section = indexPath.section
        let message = viewModel.getSelectedMessage(row: section)
        cell.elementLabel.text = message
        return cell
    }
}
// MARK: - UITableViewDelegate
extension SearchListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SearchOptions(rawValue: section)?.description
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
extension SearchListController {
    private func pushActions(options:SearchOptions) {
        switch options {
        case .place:
            let controller = DetailSearchController(toJudegeTableViewKeyword: .place, viewModel: DetailSearchViewModel(store: appStore, option: .place))
            controller.delegate = self
            navigationController?.pushViewController(controller, animated: true)
        case .institution:
            let controller = DetailSearchController(toJudegeTableViewKeyword: .institution,viewModel: DetailSearchViewModel(store: appStore, option: .institution))
            controller.delegate = self
            navigationController?.pushViewController(controller, animated: true)
        case .competition:
            let controller = DetailSearchController(toJudegeTableViewKeyword: .competition,viewModel: DetailSearchViewModel(store: appStore, option: .competition))
            controller.delegate = self
            navigationController?.pushViewController(controller, animated: true)
        case .price:
            let controller = DetailSearchController(toJudegeTableViewKeyword: .price,viewModel: DetailSearchViewModel(store: appStore, option: .price))
            controller.delegate = self
            navigationController?.pushViewController(controller, animated: true)
        case .tag:
            let controller = DetailSearchController(toJudegeTableViewKeyword: .tag,viewModel: DetailSearchViewModel(store: appStore, option: .tag))
            controller.delegate = self
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension SearchListController: DetailSearchControllerProtocol {
    func searchListController() {
        viewModel.loadUserDefaults()
        viewModel.willAppear.accept(())
    }
}
