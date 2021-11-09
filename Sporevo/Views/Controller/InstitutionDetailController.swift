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
    private let facilityInfoHeader:InsitutionHeader = InsitutionHeader(title: "設備情報")
    private let usageInfoHeader:InsitutionHeader = InsitutionHeader(title: "利用情報")
    private let insitutionHeader:InsitutionHeader = InsitutionHeader(title: "施設情報")
    private let accessHeader:InsitutionHeader = InsitutionHeader(title: "アクセス")
    private let lastInfoLabel:UILabel = {
        let label = UILabel()
        label.text = "情報のご提供をお待ちしております!"
        label.font = .systemFont(ofSize: 20, weight: .black)
        label.textColor = .darkGray
        return label
    }()
    private let stackView = UIStackView()
    private let tempView = UIView()
    private let googleMapView = UIView()
    private let textView:UITextView = {
        let textView = UITextView()
        textView.text = "SpoRevoはスポーツを愛する人みんなで作るサイトです。/n施設情報をご提供いただける方は、以下のフォームからご入力ください。/n (Googleフォームの画面に遷移します。)"
        textView.backgroundColor = .darkGray
        return textView
    }()
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
        googleMapView.backgroundColor = .darkGray
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
        let cusutomView = ComepetionView(title: "柔道", image: UIImage(systemName: "person.fill")!)
        let cusutomView2 = ComepetionView(title: "空手/少林寺拳法/合気道", image: UIImage(systemName: "person.fill")!)
        let competionStackView = UIStackView(arrangedSubviews: [cusutomView,cusutomView2])
        competionStackView.axis = .vertical
        competionStackView.distribution = .fillEqually
        competionStackView.spacing = 5
        let usageStackView = UIStackView()
        Constants.usageData.forEach {
            let label = createLabel(text: $0)
            usageStackView.addArrangedSubview(label)
        }
        usageStackView.distribution = .fillEqually
        usageStackView.axis = .vertical
        usageStackView.spacing = 15
        let facilityStackView = UIStackView()
        Constants.facilityData.forEach {
            let label = createLabel(text: $0)
            facilityStackView.addArrangedSubview(label)
        }
        facilityStackView.distribution = .fillEqually
        facilityStackView.axis = .vertical
        facilityStackView.spacing = 15
        let addressLabel = createLabel(text: "所在地:")
        let addressDetailLabel = createLabel(text: "東京都中央区1-9-2")
        let accessLabel = createLabel(text: "アクセス:")
        let accessDetailLabel = createLabel(text: "東京メトロ有楽町線「月島駅」徒歩1分")
        let parkingLabel = createLabel(text: "駐車場:")
        let addressStackView = UIStackView(arrangedSubviews: [addressLabel,addressDetailLabel])
        addressStackView.distribution = .fillEqually
        addressStackView.axis = .vertical
        addressStackView.spacing = 5
        let accessStackView = UIStackView(arrangedSubviews: [accessLabel,accessDetailLabel])
        accessStackView.axis = .vertical
        accessStackView.spacing = 5
        accessStackView.distribution = .fillEqually
        stackView.backgroundColor = .blue
        tempView.backgroundColor = .darkGray
        
        scrollView.addSubview(usageStackView)
        scrollView.addSubview(searchLabel)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(stackView)
        scrollView.addSubview(tempView)
        scrollView.addSubview(headerView)
        scrollView.addSubview(competionStackView)
        scrollView.addSubview(facilityInfoHeader)
        scrollView.addSubview(facilityStackView)
        scrollView.addSubview(accessHeader)
        scrollView.addSubview(googleMapView)
        scrollView.addSubview(addressStackView)
        scrollView.addSubview(accessStackView)
        scrollView.addSubview(parkingLabel)
        scrollView.addSubview(lastInfoLabel)
        scrollView.addSubview(textView)
        
        searchLabel.anchor(top: scrollView.topAnchor,
                           left: view.leftAnchor,
                           paddingTop: 10,
                           paddingLeft: 20,
                           height: 20)
        titleLabel.anchor(top:searchLabel.bottomAnchor,
                          paddingTop: 15,
                          centerX: view.centerXAnchor)
        stackView.anchor(top: titleLabel.bottomAnchor,
                         paddingTop: 10,
                         centerX: view.centerXAnchor,
                         width: view.frame.width,
                         height: 50)
        tempView.anchor(top: stackView.bottomAnchor,
                        left:view.leftAnchor,
                        right:view.rightAnchor,
                        paddingTop: 15,
                        paddingRight:10,
                        paddingLeft:10,
                        height: 300)
        headerView.anchor(top: tempView.bottomAnchor,
                          left: view.leftAnchor,
                          right: view.rightAnchor,
                          paddingTop: 20,height: 50)
        cusutomView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        competionStackView.anchor(top:headerView.bottomAnchor,
                                  paddingTop: 5,
                                  paddingRight: 15,
                                  paddingLeft: 15)
        scrollView.addSubview(usageInfoHeader)
        usageInfoHeader.anchor(top: competionStackView.bottomAnchor,
                               left: view.leftAnchor,
                               right: view.rightAnchor,
                               paddingTop: 5,
                               height: 50)
       
        usageStackView.anchor(top: usageInfoHeader.bottomAnchor,
                              paddingTop: 5,
                              paddingRight: 15,
                              paddingLeft: 15)
        facilityInfoHeader.anchor(top: usageStackView.bottomAnchor,
                                  left: view.leftAnchor,
                                  right: view.rightAnchor,
                                  paddingTop: 5,
                                  height: 50)
        facilityStackView.anchor(top: facilityInfoHeader.bottomAnchor,
                                 paddingTop: 5,
                                 paddingRight: 15,
                                 paddingLeft: 15)
        accessHeader.anchor(top: facilityStackView.bottomAnchor,
                            left: view.leftAnchor,
                            right: view.rightAnchor,
                            paddingTop: 5,
                            height: 50)
        googleMapView.anchor(top: accessHeader.bottomAnchor,
                             left: view.leftAnchor,
                             right: view.rightAnchor,
                             paddingTop: 10,
                             paddingRight:10,
                             paddingLeft: 10,
                             height: 300)
        addressStackView.anchor(top:googleMapView.bottomAnchor,paddingTop: 5,
                                paddingRight: 15,
                                paddingLeft: 15)
        accessStackView.anchor(top:addressStackView.bottomAnchor,paddingTop: 5,
                               paddingRight: 15,
                               paddingLeft: 15)
        parkingLabel.anchor(top:accessStackView.bottomAnchor,paddingTop: 5,
                            paddingRight: 15,
                            paddingLeft: 15)
        lastInfoLabel.anchor(top: parkingLabel.bottomAnchor,
                             paddingTop: 20,
                             centerX: view.centerXAnchor)
        textView.anchor(top: lastInfoLabel.bottomAnchor,paddingTop: 10,centerX: view.centerXAnchor,height: 200)
        
        
    }
    private func createLabel(text: String) ->UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "  \(text)"
        return label
    }
}
