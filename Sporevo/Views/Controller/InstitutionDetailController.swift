import Foundation
import UIKit

class InstitutionDetailController: UIViewController {
    private let searchLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.text = "Sporevo / 検索結果 / 月島スポーツプラザ"
        label.textColor = .darkGray
        return label
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "月島スポーツセンター"
        label.font = .systemFont(ofSize: 24, weight: .black)
        label.textColor = .darkGray
        return label
    }()
    private let headerView:InsitutionHeader = InsitutionHeader(title: "利用できる種目")
    private let stackView = UIStackView()
    private let tempView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setupUI() {
        print(#function)
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
        stackView.backgroundColor = .blue
        tempView.backgroundColor = .darkGray
        scrollView.addSubview(searchLabel)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(stackView)
        scrollView.addSubview(tempView)
        scrollView.addSubview(headerView)
        searchLabel.anchor(top:scrollView.topAnchor,
                           left: view.leftAnchor,
                           paddingTop: 10,
                           paddingLeft: 20,
                           height: 20)
        titleLabel.anchor(top:searchLabel.bottomAnchor,
                          paddingTop: 15,
                          centerX: view.centerXAnchor)
        stackView.anchor(top: titleLabel.bottomAnchor,paddingTop: 10,centerX: view.centerXAnchor,width: view.frame.width,height: 50)
        tempView.anchor(top: stackView.bottomAnchor,left:view.leftAnchor, right:view.rightAnchor, paddingTop: 15,paddingRight:10,paddingLeft:10,height: 300)
        headerView.anchor(top: tempView.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 20,height: 50)
        
        
    }
}
