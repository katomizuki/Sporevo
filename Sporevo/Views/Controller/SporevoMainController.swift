import UIKit

class SporevoMainController: UIViewController {
    // MARK: - Properties
    private var tableView:UITableView!
    private lazy var searchButton:UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        button.setTitle("検索", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .green
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        return button
    }()
    private let headerView = MainHeaderView(image: UIImage(named: "バドミントン"))
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        setupUI()
        setupNav()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - setupMethod
    private func setupUI() {
        let screenWidth = Int( UIScreen.main.bounds.size.width)
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.backgroundColor = .white
        scrollView.frame = self.view.frame
        scrollView.contentSize = CGSize(width: screenWidth, height: 1000)
        view.addSubview(scrollView)
        scrollView.anchor(top:view.safeAreaLayoutGuide.topAnchor,
                          bottom: view.bottomAnchor,
                          left: view.leftAnchor,
                          right: view.rightAnchor)
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.id)
        scrollView.addSubview(tableView)
        scrollView.addSubview(headerView)
        tableView.anchor(top:headerView.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 80,
                         paddingRight: 20,
                         paddingLeft: 20,height: 500)
        tableView.rowHeight = 60
        tableView.isScrollEnabled = false
        headerView.anchor(top:scrollView.topAnchor,
                          left: view.leftAnchor,
                          right: view.rightAnchor,
                          paddingTop: 0,
                          paddingLeft: 0)
        scrollView.addSubview(searchButton)
        searchButton.anchor(top:tableView.bottomAnchor,
                            paddingTop: 20,
                            centerX: view.centerXAnchor,
                            width: 60,
                            height: 40)
    }
    private func setupNav() {
        navigationController?.navigationBar.barTintColor = .darkGray
              let image = UIImage(systemName: "line.horizontal.3")?.withRenderingMode(.alwaysOriginal)
              navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(didTapLeftBarButton))
    }
    @objc private func didTapLeftBarButton() {
        print(#function)
    }
    @objc private func didTapSearchButton() {
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
    
}
extension SporevoMainController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(#function)
        navigationController?.navigationBar.isHidden = false
    }
}

