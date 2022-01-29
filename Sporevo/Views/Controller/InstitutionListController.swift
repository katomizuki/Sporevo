import Foundation
import UIKit
import RxSwift

class FacilityListController:UIViewController {
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        let colletionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        colletionView.register(InstitutionCell.self, forCellWithReuseIdentifier: InstitutionCell.id)
        colletionView.register(UIView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        colletionView.delegate = self
        colletionView.dataSource = self
        return colletionView
    }()
    private let disposeBag = DisposeBag()
    var facilities:Facilities?
    {
        didSet {
            if let facilities = facilities {
            viewModel.searchFacilies(facilities: facilities)
        }
      }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
//    private let headerView = MainHeaderView(image: UIImage(named: "バドミントン"))
    private let viewModel: InstituationListViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.didLoad.accept(())
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.willAppear.accept(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.willDisAppear.accept(())
    }
    
    init(viewModel:InstituationListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    

    // MARK: - setupMethod
    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              left: view.leftAnchor,
                              right: view.rightAnchor)
    }
    
    func bind() {
        viewModel.outputs.reload.subscribe { [weak self] _ in
            self?.collectionView.reloadData()
        }.disposed(by: disposeBag)
        
        viewModel.outputs.errorHandling.subscribe { _ in
            
        }.disposed(by: disposeBag)


    }
}
// MARK: - UICollectionViewDelegate
extension FacilityListController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let facility = viewModel.facility(row: indexPath.row)
        let controller = FacilityDetailController(facility: facility)
        navigationController?.pushViewController(controller, animated: true)
    }
}
// MARK: - UICollectionViewDatasource
extension FacilityListController:UICollectionViewDataSource {
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InstitutionCell.id, for: indexPath) as? InstitutionCell else { fatalError("can't make InstitutionCell") }
         let facility = viewModel.facility(row: indexPath.row)
         cell.configure(facility: facility)
        return cell
    }
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return viewModel.numberOfCells
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension FacilityListController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
}

