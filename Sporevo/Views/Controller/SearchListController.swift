import Foundation
import UIKit
import ReSwift

protocol SearchListControllerProtocol:AnyObject {
    func searchListController()
}
final class SearchListController: UIViewController {
    // MARK: - Properties
    private var toJudegeTableViewKeyword:SearchOptions
    private var searchListPresentar:SearchListInputs!
    private lazy var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchListCell.self, forCellReuseIdentifier: SearchListCell.id)
        return tableView
    }()
    weak var delegate:SearchListControllerProtocol?
    private var selectedCell:[String:Bool] = [String:Bool]()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupNav()
        searchListPresentar.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appStore.subscribe(self)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        appStore.unsubscribe(self)
    }
    // MARK: - Initialize
    init(toJudegeTableViewKeyword: SearchOptions) {
        self.toJudegeTableViewKeyword = toJudegeTableViewKeyword
        super.init(nibName: nil, bundle: nil)
        searchListPresentar = SearchListPresentar(outputs: self,option: toJudegeTableViewKeyword)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - setupMethod
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.anchor(top:view.safeAreaLayoutGuide.topAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor)
        tableView.allowsMultipleSelection = true
    }
    private func setupNav() {
        let leftButton = UIBarButtonItem(title: "もどる", style: .done, target: self, action: #selector(didTapLeftBarButton))
        navigationItem.leftBarButtonItem = leftButton
        leftButton.tintColor = .systemMint
    }
    @objc private func didTapLeftBarButton() {
        searchListPresentar.saveUserDefaults()
        navigationController?.popViewController(animated: true)
        self.delegate?.searchListController()
    }
}
// MARK: - UITableViewDelegate
extension SearchListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        guard let cell = tableView.cellForRow(at: indexPath) as? SearchListCell else { return }
        searchListPresentar.didSelectRowAt(indexPath: indexPath)
        if toJudegeTableViewKeyword == .place || toJudegeTableViewKeyword == .price {
            if indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            searchListPresentar.didTapSection(section: indexPath.section)
            } else {
                let key = "\(indexPath.section) + \(indexPath.row)"
                if cell.accessoryType == .none {
                    cell.accessoryType = .checkmark
                    selectedCell[key] = true
                } else {
                    cell.accessoryType = .none
                    selectedCell.removeValue(forKey: key)
                }
            }
        } else {
        let key = "\(indexPath.row)"
        if cell.accessoryType == .none {
            cell.accessoryType = .checkmark
            selectedCell[key] = true
        } else {
            cell.accessoryType = .none
            selectedCell.removeValue(forKey: key)
        }
    }
 }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        // cellの.no
        let key = "\(indexPath.row)"
        if cell.accessoryType == .none {
            cell.accessoryType = .checkmark
            selectedCell[key] = true
        } else {
            cell.accessoryType = .none
            selectedCell.removeValue(forKey: key)
        }
        searchListPresentar.didSelectRowAt(indexPath: indexPath)
    }
}
// MARK: - UITableViewDataSource
extension SearchListController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchListPresentar.sectionsCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchListCell.id,for: indexPath) as? SearchListCell else { fatalError("can't make SearchListCell Error") }
        cell.textLabel?.text = searchListPresentar.getMessage(indexPath: indexPath)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if toJudegeTableViewKeyword == .price || toJudegeTableViewKeyword == .place {
            let key = "\(indexPath.section) + \(indexPath.row)"
            if indexPath.row == 0 { cell.sectionImageView.isHidden = false }
            if selectedCell[key] != nil {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else {
        let key = "\(indexPath.row)"
        if selectedCell[key] != nil {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchListPresentar.numberOfCell(section: section)
    }
}
// MARK: - SearchListOutputs
extension SearchListController:SearchListOutputs {
    func reloadSections(section: Int) {
        DispatchQueue.main.async {
            self.tableView.reloadSections([section], with: .fade)
        }
    }
    func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
extension SearchListController:StoreSubscriber {
    
    typealias StoreSubscriberStateType = AppState
    
    func newState(state: StoreSubscriberStateType) {
        searchListPresentar.citySections = state.detailState.placeSections
        searchListPresentar.tags = state.detailState.tags
        searchListPresentar.sports = state.detailState.sports
        searchListPresentar.moneySections = state.detailState.moneySections
        searchListPresentar.facilities = state.detailState.facilityType
        searchListPresentar.selectedCity = state.detailState.selectedCity
        searchListPresentar.selectedInstion = state.detailState.selectedInstion
        searchListPresentar.selectedCompetion = state.detailState.selectedCompetion
        searchListPresentar.selectedPrice = state.detailState.selectedPrice
        searchListPresentar.selectedTag = state.detailState.selectedTag
    }
    
    
}

