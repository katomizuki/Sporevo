import Foundation
import UIKit

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
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        
        searchListPresentar.viewDidLoad(toJudegeTableViewKeyword)
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
        searchListPresentar = SearchListPresentar(outputs: self,model: FetchFacility(),option: toJudegeTableViewKeyword,sports: FetchSports(), tags: FetchTags(),moneyUnit: FetchMoney(),prefecture: FetchPrefecture())
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
}
// MARK: - UITableViewDelegate
extension SearchListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = .clear
        searchListPresentar.didSelectRowAt(id: indexPath.row)
    }

}
// MARK: - UITableViewDataSource
extension SearchListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchListCell.id,for: indexPath) as? SearchListCell else { fatalError("can't make SearchListCell Error") }
        cell.textLabel?.text = getMessage(row: indexPath.row)
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(searchListPresentar.numberOfCell)
        return searchListPresentar.numberOfCell
    }
}
// MARK: - SearchListOutputs
extension SearchListController:SearchListOutputs {
    func reload() {
        tableView.reloadData()
    }
    func detailListController(id:Int) {
        let controller = DetailListController(option: toJudegeTableViewKeyword, apiID: id + 1)
        navigationController?.pushViewController(controller, animated: true)
    }
}
extension SearchListController {
    private func getMessage(row:Int)->String {
        var message = String()
        switch toJudegeTableViewKeyword {
        case .institution:
            let model = searchListPresentar.facility(row: row)
            message = model.name
        case.competition:
            let model = searchListPresentar.sport(row: row)
            message = model.name
        case .place:
            let model = searchListPresentar.prefecture(row: row)
            message = model.name
        case .price:
            let model = searchListPresentar.moneyUnit(row: row)
            message = model.name
        case .tag:
            let model = searchListPresentar.tag(row: row)
           message = model.name
        }
        return message
    }
}
