import Foundation
import UIKit

class SearchDetailController:UIViewController {
    
    private var tableView:UITableView!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.id)
        view.addSubview(tableView)
        tableView.anchor(top:view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 80,
                         paddingRight: 20,
                         paddingLeft: 20,height: 500)
        tableView.rowHeight = 60
        tableView.isScrollEnabled = false
        view.addSubview(searchButton)
        searchButton.anchor(top:tableView.bottomAnchor,
                            paddingTop: 20,
                            centerX: view.centerXAnchor,
                            width: 60,
                            height: 40)
    }
}
// MARK: - SearchCellDelegate
extension SearchDetailController:SeachCellDelegate {
    func searchCell(_ cell: SearchCell) {
        print(#function)
        guard let options = SearchOptions(rawValue: tableView.indexPath(for: cell)?.section ?? 0) else { return }
        switch options {
        case .place:
            navigationController?.pushViewController(SearchListController(toJudegeTableViewKeyword: .place), animated: true)
        case .institution:
            navigationController?.pushViewController(SearchListController(toJudegeTableViewKeyword: .institution), animated: true)
        case .competition:
            navigationController?.pushViewController(SearchListController(toJudegeTableViewKeyword: .competition), animated: true)
        case .price:
            navigationController?.pushViewController(SearchListController(toJudegeTableViewKeyword: .price), animated: true)
        case .tag:
            navigationController?.pushViewController(SearchListController(toJudegeTableViewKeyword: .tag), animated: true)
        }
    }
    @objc private func didTapSearchButton() {
        print(#function)
    }
}
// MARK: - UITableViewDataSource
extension SearchDetailController: UITableViewDataSource {
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
// MARK: - UITableViewDelegate
extension SearchDetailController: UITableViewDelegate {
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
