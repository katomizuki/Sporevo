import UIKit

class SporevoMainController: UIViewController {
    // MARK: - Properties
    private var tableView:UITableView!
//    private let scrollView:UIScrollView
    private let headerView = MainHeaderView(image: UIImage(named: "バドミントン"))
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHeader()
        setupTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - setupMethod
    private func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.id)
        view.addSubview(tableView)
        tableView.anchor(top:headerView.bottomAnchor,
                         bottom: view.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 80,
                         paddingRight: 20,
                         paddingLeft: 20)
        tableView.rowHeight = 60
        tableView.isScrollEnabled = true
        tableView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: view.frame.width - 40,
                                 height: view.frame.height - headerView.frame.width)
    }
    private func setupHeader() {
        view.addSubview(headerView)
        headerView.anchor(top:view.topAnchor,
                          left: view.leftAnchor,
                          right: view.rightAnchor,
                          paddingTop: 0,
                          paddingLeft: 0)
    }
    func didTapSearchPlusButton(_ cell:UITableViewCell) {
        print(#function)
    }
}
// MARK: - UITableViewDelegate
extension SporevoMainController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SearchOptions(rawValue: section)?.description
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}
// MARK: - UITableViewDataSource
extension SporevoMainController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SearchOptions.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.id, for: indexPath) as? SearchCell else { fatalError("can't make SeachCell Error") }
        cell.delegate = self
        return cell
    }
}
// MARK: - SearchCellDelegate
extension SporevoMainController:SeachCellDelegate {
    func searchCell(_ cell: SearchCell) {
        print(#function)
        guard let options = SearchOptions(rawValue: tableView.indexPath(for: cell)?.section ?? 0) else { return }
        switch options {
        case .place:
            print("place")
            navigationController?.pushViewController(SearchListController(), animated: true)
        case .institution:
            print("")
        case .competition:
            print("competition")
        case .price:
            print("price")
        case .tag:
            print("tag")

    }
  }
    
}

