import Foundation
import UIKit
import ReSwift
import RxSwift

protocol DetailSearchControllerProtocol:AnyObject {
    func searchListController()
}
final class DetailSearchController: UIViewController {
    // MARK: - Properties
    private var toJudegeTableViewKeyword:SearchOptions
    private let viewModel: DetailSearchViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchListCell.self, forCellReuseIdentifier: SearchListCell.id)
        return tableView
    }()
    weak var delegate:DetailSearchControllerProtocol?
    private var selectedCell:[String:Bool] = [String: Bool]()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupNav()
        bind()
        viewModel.didLoad.accept(())
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.willAppear.accept(())
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.willDisAppear.accept(())
    }
    // MARK: - Initialize
    init(toJudegeTableViewKeyword: SearchOptions,viewModel: DetailSearchViewModel) {
        self.toJudegeTableViewKeyword = toJudegeTableViewKeyword
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - setupMethod
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.anchor(top:view.safeAreaLayoutGuide.topAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor)
        tableView.allowsMultipleSelection = true
    }
    private func setupNav() {
        let leftButton = UIBarButtonItem(title: "もどる", style: .done, target: self, action: #selector(didTapLeftBarButton))
        navigationItem.leftBarButtonItem = leftButton
        leftButton.tintColor = .systemMint
    }
    @objc private func didTapLeftBarButton() {
        viewModel.saveUserDefaults()
        navigationController?.popViewController(animated: true)
        self.delegate?.searchListController()
    }
    func bind() {
        
        viewModel.outputs.reload.observe(on: MainScheduler.instance)
            .subscribe { [weak self] _  in
                guard let self = self else { return }
                self.tableView.reloadData()
            }.disposed(by: disposeBag)
        
        viewModel.outputs.reloadSections.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] section in
                guard let self = self else { return }
                self.tableView.reloadSections([section], with: .bottom)
            }).disposed(by: disposeBag)
        
    }
}
// MARK: - UITableViewDelegate
extension DetailSearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SearchListCell else { return }
        viewModel.didSelectRowAt(indexPath: indexPath)
        if toJudegeTableViewKeyword == .place || toJudegeTableViewKeyword == .price {
            if indexPath.row == 0 {
                tableView.deselectRow(at: indexPath, animated: true)
                viewModel.didTapSection(section: indexPath.section)
            } else {
                let key = "\(indexPath.section) + \(indexPath.row)"
                if cell.accessoryType == .none {
                    cell.accessoryType = .checkmark
                    selectedCell[key] = true
                } else {
                    cell.accessoryType = .none
                    selectedCell.removeValue(forKey: key)
                }
            }
        } else {
            let key = "\(indexPath.row)"
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
                selectedCell[key] = true
            } else {
                cell.accessoryType = .none
                selectedCell.removeValue(forKey: key)
            }
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        // cellの.no
        let key = "\(indexPath.row)"
        if cell.accessoryType == .none {
            cell.accessoryType = .checkmark
            selectedCell[key] = true
        } else {
            cell.accessoryType = .none
            selectedCell.removeValue(forKey: key)
        }
        viewModel.didSelectRowAt(indexPath: indexPath)
    }
}
// MARK: - UITableViewDataSource
extension DetailSearchController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionsCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchListCell.id,for: indexPath) as? SearchListCell else { fatalError("can't make SearchListCell Error") }
        cell.textLabel?.text = viewModel.getMessage(indexPath: indexPath)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if toJudegeTableViewKeyword == .price || toJudegeTableViewKeyword == .place {
            let key = "\(indexPath.section) + \(indexPath.row)"
            if indexPath.row == 0 { cell.sectionImageView.isHidden = false }
            if selectedCell[key] != nil {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else {
            let key = "\(indexPath.row)"
            if selectedCell[key] != nil {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCell(section: section)
    }
}
