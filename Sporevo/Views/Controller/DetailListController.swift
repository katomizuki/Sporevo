import Foundation
import UIKit

class DetailListController:UIViewController {
    private lazy var tableView:UITableView = {
        let tb = UITableView()
        tb.delegate = self
        tb.dataSource = self
        tb.register(SearchListCell.self, forCellReuseIdentifier: SearchListCell.id)
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.anchor(top:view.topAnchor,bottom: view.bottomAnchor,
                         left: view.leftAnchor,right: view.rightAnchor)
    }
}
// MARK: - DetailListController
extension DetailListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
    }
}
// MARK: - UITableViewDataSource
extension DetailListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.id, for: indexPath) as? SearchListCell else { fatalError("can't make SearchListCell") }
        return cell
    }
}
