import UIKit

class SporevoMainController: UIViewController {
    // MARK: - Properties
    private lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.id)
        return tableView
    }()
//    private let scrollView:UIScrollView
    private let headerView = MainHeaderView(image: UIImage(named: "バドミントン"))
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHeader()
        setupTableView()
    }
    // MARK: - setupMethod
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.anchor(top:headerView.bottomAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 30,
                         paddingBottom: 0,
                         paddingRight: 0,
                         paddingLeft: 0)
        tableView.rowHeight = 60
        tableView.isScrollEnabled = false
    }
    private func setupHeader() {
        view.addSubview(headerView)
        headerView.anchor(top:view.safeAreaLayoutGuide.topAnchor,
                          left: view.leftAnchor,
                          right: view.rightAnchor,
                          paddingTop: 0,
                          paddingLeft: 0,
                          height: 130)
    }


}
// MARK: - UITableViewDelegate
extension SporevoMainController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SearchOptions(rawValue: section)?.description
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
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
        return cell
    }
}

