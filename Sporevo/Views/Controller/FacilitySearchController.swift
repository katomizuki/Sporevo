import Foundation
import UIKit
import ReSwift

protocol FacilitySearchControllerDelegate:AnyObject {
    func facilitySearchController(_ controller:FacilitySearchController)
}

final class FacilitySearchController:UIViewController {
    // MARK: - Properties
    private var tableView:UITableView = UITableView(frame: .zero, style: .insetGrouped)
    weak var delegate:FacilitySearchControllerDelegate?
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
    private var presentar:FacilitySearchPresentar!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presentar = FacilitySearchPresentar(outputs: self)
        appStore.subscribe(self)
        setupUI()
        presentar.deleteUserDefaults()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        appStore.unsubscribe(self)
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
        presentar.deleteUserDefaults()
        dismiss(animated: true, completion: nil)
        
    }
}
// MARK: - SearchCellDelegate
extension FacilitySearchController:SeachCellDelegate {
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
extension FacilitySearchController: UITableViewDataSource {
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
        let message = presentar.getSelectedMessage(row: section)
        cell.elementLabel.text = message
        return cell
    }
}
// MARK: - UITableViewDelegate
extension FacilitySearchController: UITableViewDelegate {
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
extension FacilitySearchController {
    private func pushActions(options:SearchOptions) {
        switch options {
        case .place:
            let controller = SearchListController(toJudegeTableViewKeyword: .place)
            controller.delegate = self
            navigationController?.pushViewController(controller, animated: true)
        case .institution:
            let controller = SearchListController(toJudegeTableViewKeyword: .institution)
            controller.delegate = self
            navigationController?.pushViewController(controller, animated: true)
        case .competition:
            let controller = SearchListController(toJudegeTableViewKeyword: .competition)
            controller.delegate = self
            navigationController?.pushViewController(controller, animated: true)
        case .price:
            let controller = SearchListController(toJudegeTableViewKeyword: .price)
            controller.delegate = self
            navigationController?.pushViewController(controller, animated: true)
        case .tag:
            let controller = SearchListController(toJudegeTableViewKeyword: .tag)
            controller.delegate = self
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
extension FacilitySearchController:FacilitySearchOutputs {
    func showError(_ error: Error) {
        
    }
    func reload() {
        tableView.reloadData()
    }
}
extension FacilitySearchController: SearchListControllerProtocol {
    func searchListController() {
        presentar.loadUserDefaults()
        appStore.subscribe(self)
    }
}
extension FacilitySearchController:StoreSubscriber {    
    typealias StoreSubscriberStateType = AppState
    func newState(state: StoreSubscriberStateType) {
        print(state.facilitySearchState.selectedTag)
        presentar.selectedTag = state.facilitySearchState.selectedTag
        presentar.selectedCity = state.facilitySearchState.selectedCity
        presentar.selectedSports = state.facilitySearchState.selectedSports
        presentar.selectedFacility = state.facilitySearchState.selectedFacility
        presentar.selectedPriceUnits = state.facilitySearchState.selectedPriceUnits
        presentar.reload()
    }
}
