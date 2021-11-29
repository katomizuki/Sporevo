
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
    private let headerView = MainHeaderView(image: UIImage(named: "バドミントン"))
    private var presentar:InstituationPresentarInputs!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setupUI()
        presentar = InstituationPresentar(outputs: self)
        presentar.viewDidLoad()
    }

    // MARK: - setupMethod
    private func setupUI() {
        let screenWidth = Int( UIScreen.main.bounds.size.width)
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.frame = self.view.frame
        scrollView.contentSize = CGSize(width: screenWidth, height: 1500)
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
                              paddingTop: 70,
                              paddingRight: 20,
                              paddingLeft: 20,height: 1200)
    }
}
// MARK: - UICollectionViewDelegate
extension InstitutionListController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
        let controller = InstitutionDetailController()
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
        collectionView.reloadData()
    }
}
