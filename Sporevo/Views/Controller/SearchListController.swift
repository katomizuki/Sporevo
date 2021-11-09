import Foundation
import UIKit

class SearchListController: UIViewController {
    private let cityData = Constants.cityData
    private let tagData = Constants.tagData
    private let institutionData = Constants.institutionData
    private let competionData = Constants.competitionData
    private var isExpanded = false
    private var toJudegeTableViewKeyword:SearchOptions
    private var sections:[(title:String,detail: [String],extended:Bool)] = []
    private lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupSectionValue()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.isHidden = false
    }
    init(toJudegeTableViewKeyword: SearchOptions) {
        self.toJudegeTableViewKeyword = toJudegeTableViewKeyword
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupSectionValue() {
        if toJudegeTableViewKeyword == .place {
            let details = Constants.cityData
            sections.append((title:"東京都" , detail: details, extended: false))
        } else  {
            for i in 0..<Constants.priceData.count {
                let details = Constants.priceData[i]
                let title = Constants.timeData[i]
                sections.append((title: title, detail: details, extended: false))
            }
        }
       
    }
    
    private func setupTableView() {
        print(#function)
        view.addSubview(tableView)
        tableView.anchor(top:view.safeAreaLayoutGuide.topAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,paddingTop: 50)
    }
}
// MARK: - UITableViewDelegate
extension SearchListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if toJudegeTableViewKeyword == .price || toJudegeTableViewKeyword == .place {
        var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomHeaderFooterView.id) as? CustomHeaderFooterView
        if header == nil {
            header = CustomHeaderFooterView(reuseIdentifier: CustomHeaderFooterView.id)
            header?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHeader)))
        }
        header?.textLabel?.text = sections[section].title
        header?.section = section
        return header
        } else { return nil
            
        }
    }
    @objc private func tapHeader(sender:UITapGestureRecognizer) {
        print(#function)
        guard let header = sender.view as? CustomHeaderFooterView else { return }
        let extended = sections[header.section].extended
        sections[header.section].extended = !extended
        tableView.reloadSections(IndexSet(integer: header.section), with: .none)
    }
}
// MARK: - UITableViewDataSource
extension SearchListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId",for: indexPath)
        switch toJudegeTableViewKeyword {
        case .institution: cell.textLabel?.text = institutionData[indexPath.row]
        case .competition: cell.textLabel?.text = competionData[indexPath.row]
        case .tag: cell.textLabel?.text = tagData[indexPath.row]
        default:
            cell.textLabel?.text = sections[indexPath.section].detail[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch toJudegeTableViewKeyword {
        case .tag: return tagData.count
        case .competition: return competionData.count
        case .institution: return institutionData.count
        default: return sections[section].extended ? sections[section].detail.count : 0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
            if toJudegeTableViewKeyword == .price || toJudegeTableViewKeyword == .place {
                return sections.count
            } else {
                return 1
            }
    }
}

