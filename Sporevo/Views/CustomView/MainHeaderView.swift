
import Foundation
import UIKit

class MainHeaderView: UIImageView {
    // MARK: - Propertis
    private let titleView:UIView = {
       let subTitleLabel = UILabel()
       let titleLabel = UILabel()
        subTitleLabel.text = "今すぐスポーツ施設を検索"
        titleLabel.text = "〇〇施設掲載中!"
        subTitleLabel.textColor = .white
        titleLabel.textColor = .white
        subTitleLabel.font = .systemFont(ofSize: 18, weight: .heavy)
        subTitleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 20, weight: .black)
        titleLabel.textAlignment = .center
       let view = UIView()
       let whiteLine = UIView()
        whiteLine.backgroundColor = .white
        view.addSubview(whiteLine)
        view.addSubview(subTitleLabel)
        view.addSubview(titleLabel)
        whiteLine.anchor(left:view.leftAnchor,
                         right: view.rightAnchor,
                         centerY:view.centerYAnchor,
                         height: 2)
        subTitleLabel.anchor(bottom:whiteLine.topAnchor,
                             left:view.leftAnchor,
                             right: view.rightAnchor,height: 30)
        titleLabel.anchor(top:whiteLine.bottomAnchor,
                          left:view.leftAnchor,
                          right: view.rightAnchor,paddingTop:-10,height: 50)
        view.backgroundColor = .clear
        return view
    }()
    
    
    // MARK: Initialize
    override init(image: UIImage?) {
        super.init(image: image)
        addSubview(titleView)
        contentMode = .scaleAspectFill
        titleView.anchor(bottom: bottomAnchor,
                         paddingBottom: 10,
                         centerX:centerXAnchor,
                         width: 250,
                         height: 80)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
