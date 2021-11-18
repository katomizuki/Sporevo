import UIKit
import Alamofire
protocol SporevoMainControllerDelegate: AnyObject {
    func handleMenuToggle(forMenuOptions menuOptions: MenuOptions?)
}
class SporevoMainController: UIViewController {
    // MARK: - Properties
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        let colletionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        colletionView.register(InstitutionCell.self, forCellWithReuseIdentifier: InstitutionCell.id)
        colletionView.delegate = self
        colletionView.dataSource = self
        return colletionView
    }()
    private lazy var segmentController :UISegmentedControl = {
        let segment = UISegmentedControl(items: ["地図で探す","一覧"])
        segment.addTarget(self, action: #selector(didChangeSegmentController), for: .valueChanged)
        return segment
    }()
    private let headerView = MainHeaderView(image: UIImage(named: "バドミントン"))
    weak var delegate: SporevoMainControllerDelegate?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        setupUI()
        setupNav()
        setupAPI()
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
        scrollView.backgroundColor = .white
        scrollView.frame = self.view.frame
        scrollView.contentSize = CGSize(width: screenWidth, height: 2100)
        view.addSubview(scrollView)
        scrollView.anchor(top:view.safeAreaLayoutGuide.topAnchor,
                          bottom: view.bottomAnchor,
                          left: view.leftAnchor,
                          right: view.rightAnchor)
        scrollView.addSubview(headerView)

      
        headerView.anchor(top:scrollView.topAnchor,
                          left: view.leftAnchor,
                          right: view.rightAnchor,
                          paddingTop: 0,
                          paddingLeft: 0)

        scrollView.addSubview(collectionView)
        collectionView.anchor(top:headerView.bottomAnchor,
                              left: view.leftAnchor,
                              right: view.rightAnchor,
                              paddingTop: 80,
                              paddingRight: 20,
                              paddingLeft: 20,height: 1200)
    }
    private func setupNav() {
        navigationController?.navigationBar.barTintColor = .darkGray
              let image = UIImage(systemName: "line.horizontal.3")?.withRenderingMode(.alwaysOriginal)
              navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(didTapLeftBarButton))
        let searchImage = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: searchImage, style: .done, target: self, action: #selector(didTapSearchDetailButton))
        navigationItem.titleView = segmentController
    }
    private func setupAPI() {
        let authData = "LIcCke0gTSNAloR7ptYq".data(using: String.Encoding.utf8)!
        let authBase64 = authData.base64EncodedString()
        let header:HTTPHeaders = ["Authorization":authBase64,
                                  "Content-Type": "application/json"]
        
        AF.request("https://spofac-staging.herokuapp.com/prefectures", method: .get, headers: header).validate(statusCode: 200...400).responseString { response in
            print(response.result,response.data)
        }

        
    }
    @objc private func didTapLeftBarButton() {
        print(#function)
        delegate?.handleMenuToggle(forMenuOptions: nil)
    }
    @objc private func didTapSearchDetailButton() {
        print(#function)
        let controller = SearchDetailController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    @objc private func didChangeSegmentController(sender: UISegmentedControl) {
        
    }
}
// MARK: - UICollectionViewDelegate
extension SporevoMainController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
        let controller = InstitutionDetailController()
        navigationController?.pushViewController(controller, animated: true)
    }
}
// MARK: - UICollectionViewDatasource
extension SporevoMainController:UICollectionViewDataSource {
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InstitutionCell.id, for: indexPath) as? InstitutionCell else { fatalError("can't make InstitutionCell") }
        return cell
    }
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension SporevoMainController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 250)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

struct Prefer:Decodable {
    var id:String
    var name:String
}
