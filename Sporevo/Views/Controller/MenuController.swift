import Foundation
import UIKit
class MenuController:UIViewController {
    // MARK: - Properties
    var tableView:UITableView!
    weak var delegate: SporevoMainControllerDelegate?
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        setupTableView()
    }
    // MARK: - setupMethod
    private func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .darkGray
        tableView.register(MenuOptionsCell.self, forCellReuseIdentifier: MenuOptionsCell.id)
        view.addSubview(tableView)
        tableView.anchor(top:view.topAnchor,
                         bottom:view.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor)
    }
}
// MARK: - UITableViewDelegate
extension MenuController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        guard let menuOption = MenuOptions(rawValue: indexPath.row) else { return }
        delegate?.handleMenuToggle(forMenuOptions: menuOption)
    }
}
// MARK: - UITableViewDataSource
extension MenuController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuOptionsCell.id, for: indexPath) as? MenuOptionsCell else { fatalError("Can’ｔ make MenuOptionsCell Error") }
        cell.desciptionLabel.text = MenuOptions(rawValue: indexPath.row)?.description
        cell.iconImageView.image = MenuOptions(rawValue: indexPath.row)?.icon
        return cell
    }
}

