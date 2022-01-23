import Foundation
import UIKit

class InstitutionListController:UIViewController {
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        let colletionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        colletionView.register(InstitutionCell.self, forCellWithReuseIdentifier: InstitutionCell.id)
        colletionView.delegate = self
        colletionView.dataSource = self
        return colletionView
    }()
    var navigationHeight: CGFloat
    var facilities:Facilities?
    {
        didSet {
            if let facilities = facilities {
            presentar.searchFacilies(facilities: facilities)
        }
      }
    }
     init(height:CGFloat) {
        self.navigationHeight = height
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
//    private let headerView = MainHeaderView(image: UIImage(named: "バドミントン"))
    private var presentar:InstituationPresentarInputs!
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupUI()
        presentar = InstituationPresentar(outputs: self)
        presentar.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }

    // MARK: - setupMethod
    private func setupUI() {
        view.addSubview(collectionView)
        navigationHeight = (self.navigationController?.navigationBar.frame.height)!
        
        collectionView.anchor(top: view.topAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              left: view.leftAnchor,
                              right: view.rightAnchor, paddingTop: self.navigationHeight)
    }
}
// MARK: - UICollectionViewDelegate
extension InstitutionListController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let facility = presentar.facility(row: indexPath.row)
        let controller = InstitutionDetailController(facility: facility)
        navigationController?.pushViewController(controller, animated: true)
    }
}
// MARK: - UICollectionViewDatasource
extension InstitutionListController:UICollectionViewDataSource {
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InstitutionCell.id, for: indexPath) as? InstitutionCell else { fatalError("can't make InstitutionCell") }
         let facility = presentar.facility(row: indexPath.row)
         cell.configure(facility: facility)
        return cell
    }
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return presentar.numberOfCells
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension InstitutionListController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 250)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
// MARK: - InstituationPresentarOutputs
extension InstitutionListController:InstituationPresentarOutputs {
    func reload() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
