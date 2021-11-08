import UIKit

class SporevoMainController: UIViewController {
    // MARK: - Properties
    private lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        return tableView
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
    }
    // MARK: - setupMethod
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.anchor(top:view.safeAreaLayoutGuide.topAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 0,
                         paddingBottom: 0,
                         paddingRight: 0,
                         paddingLeft: 0)
    }


}
// MARK: - UITableViewDelegate
extension SporevoMainController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.backgroundColor = .cyan
        return cell
    }
}

