import Foundation
import UIKit

class SearchListController: UIViewController {
    private var toJudegeTableViewKeyword:SearchOptions
   
    private var searchListPresentar:SearchListInputs!
    private lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchListCell.self, forCellReuseIdentifier: SearchListCell.id)
        return tableView
    }()
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
    init(toJudegeTableViewKeyword: SearchOptions) {
        self.toJudegeTableViewKeyword = toJudegeTableViewKeyword
        super.init(nibName: nil, bundle: nil)
        searchListPresentar = SearchListPresentar(outputs: self,model: FetchFacility(),option: toJudegeTableViewKeyword,sports: FetchSports())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    private func setupTableView() {
        print(#function)
        view.addSubview(tableView)
        tableView.anchor(top:view.safeAreaLayoutGuide.topAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,paddingTop: 50)
        tableView.allowsMultipleSelection = true
    }
}
// MARK: - UITableViewDelegate
extension SearchListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        searchListPresentar.didSelectRowAt()
    }
}
// MARK: - UITableViewDataSource
extension SearchListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchListCell.id,for: indexPath) as? SearchListCell else { fatalError("can't make SearchListCell Error") }
        switch toJudegeTableViewKeyword {
        case .institution:
            let model = searchListPresentar.facility(row: indexPath.row)
            cell.textLabel?.text = model.name
        case.competition:
            let model = searchListPresentar.sport(row: indexPath.row)
            cell.textLabel?.text = model.name
        case .place: print("ss")
        case .price: print("ss")
        case .tag: print("ss")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(searchListPresentar.numberOfCell)
        return searchListPresentar.numberOfCell
    }
}

extension SearchListController:SearchListOutputs {
    func reload() {
        tableView.reloadData()
    }
}
