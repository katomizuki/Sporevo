import Foundation
import UIKit

class DetailListController:UIViewController {
    // MARK: - Properties
    private lazy var tableView:UITableView = {
        let tb = UITableView()
        tb.delegate = self
        tb.dataSource = self
        tb.register(SearchListCell.self, forCellReuseIdentifier: SearchListCell.id)
        return tb
    }()
    private var option:SearchOptions
    private var apiID:Int?
    private var presentar:DetailSearchInputs!
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.anchor(top:view.topAnchor,bottom: view.bottomAnchor,
                         left: view.leftAnchor,right: view.rightAnchor)
        presentar.viewdidLoad()
        setupNav()
        tableView.allowsMultipleSelection = true
    }
    // MARK: - Initialize
    init(option:SearchOptions,apiID:Int) {
        self.option = option
        self.apiID = apiID
        super.init(nibName: nil, bundle: nil)
        presentar = DetailListPresentar(output: self, city: FetchPrefecture(), priceUnit: FetchMoney(),option: option,apiID:apiID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupNav() {
        let leftButton = UIBarButtonItem(title: "もどる", style: .done, target: self, action: #selector(didTapPopButton))
        navigationItem.leftBarButtonItem = leftButton
        leftButton.tintColor = .systemMint
    }
    @objc private func didTapPopButton() {
        print(#function)
        presentar.saveUserDefaults()
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - DetailListController
extension DetailListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentar.didTapCell(row: indexPath.row)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        presentar.didTapCell(row: indexPath.row)
    }
}
// MARK: - UITableViewDataSource
extension DetailListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presentar.numberOfCell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchListCell.id, for: indexPath) as? SearchListCell else { fatalError("can't make SearchListCell") }
        cell.textLabel?.text = getMessage(row: indexPath.row)
        return cell
    }
}
// MARK: - DetailSearchOutputs
extension DetailListController:DetailSearchOutputs {
    func reload() {
        tableView.reloadData()
    }
}
// MARK: - HelperMethod
extension DetailListController {
    private func getMessage(row:Int)->String {
        var message = String()
        if option == .place {
            let model = presentar.city(row: row)
            message = model.name
        } else if option == .price {
            let model = presentar.priceUnit(row: row)
            message = model.name
        }
        return message
    }
}
