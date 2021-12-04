import Foundation
import UIKit

protocol SearchListControllerProtocol:AnyObject {
    func searchListController()
}
final class SearchListController: UIViewController {
    // MARK: - Properties
    private var toJudegeTableViewKeyword:SearchOptions
    private var searchListPresentar:SearchListInputs!
    private lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchListCell.self, forCellReuseIdentifier: SearchListCell.id)
        return tableView
    }()
    weak var delegate:SearchListControllerProtocol?
    private var selectedCell:[String:Bool] = [String:Bool]()
    private let indicator = UIActivityIndicatorView()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupNav()
        searchListPresentar.viewDidLoad(toJudegeTableViewKeyword)
        view.addSubview(indicator)
        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        indicator.center = view.center
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.isHidden = false
    }
    // MARK: - Initialize
    init(toJudegeTableViewKeyword: SearchOptions) {
        self.toJudegeTableViewKeyword = toJudegeTableViewKeyword
        super.init(nibName: nil, bundle: nil)
        searchListPresentar = SearchListPresentar(outputs: self,model: FetchFacilityType(),option: toJudegeTableViewKeyword,sports: FetchSports(), tags: FetchTags(),moneyUnit: FetchMoney(),prefecture: FetchPrefecture(),city: FetchPrefecture())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - setupMethod
    private func setupTableView() {
        print(#function)
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
        print(#function)
        searchListPresentar.saveUserDefaults()
        navigationController?.popViewController(animated: true)
        self.delegate?.searchListController()
    }
}
// MARK: - UITableViewDelegate
extension SearchListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        if toJudegeTableViewKeyword == .place || toJudegeTableViewKeyword == .price {
            if indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            searchListPresentar.didTapSection(section: indexPath.section)
            } else {
                print("tap sub cell")
            }
        } else {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        searchListPresentar.didSelectRowAt(id: indexPath.row)
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
        searchListPresentar.didSelectRowAt(id: indexPath.row)
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
        let key = "\(indexPath.row)"
        if selectedCell[key] != nil {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
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
            self.tableView.reloadSections([section], with: .none)
        }
    }
    func reload() {
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    func detailListController(id:Int) {
        let controller = DetailListController(option: toJudegeTableViewKeyword, apiID: id + 1)
        navigationController?.pushViewController(controller, animated: true)
    }
}
