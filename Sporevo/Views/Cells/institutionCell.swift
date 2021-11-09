import Foundation
import UIKit

class InstitutionCell: UICollectionViewCell {
    static let id = "InstitutionCell"
    private let tagData = Constants.tagData
    private let institutionNameLabel:UILabel = {
        let label = UILabel()
        label.text = " 新国立競技場 - "
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 24, weight: .black)
        label.layer.borderColor = UIColor.darkGray.cgColor
        label.layer.borderWidth = 2
        return label
    }()
    private let addressLabel: UILabel = {
        let label = UILabel()
        let iv = UIImageView()
        iv.image = UIImage(systemName: "mappin.and.ellipse")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .darkGray
        label.addSubview(iv)
        iv.anchor(right:label.leftAnchor,paddingRight: 3,centerY: label.centerYAnchor,width: 20,height: 20)
        label.text = " 東京都中央区日本橋浜町2-59-1浜町公園内"
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.sizeToFit()
        return label
    }()
    private let competitionLabel: UILabel = {
        let label = UILabel()
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .darkGray
        label.addSubview(iv)
        iv.anchor(top:label.topAnchor,right:label.leftAnchor,paddingTop: 5,paddingRight: 3,width: 20,height: 20)
        label.text = "卓球 バドミントン バレーボール バスケットボール ダンス 剣道／なぎなた 空手／少林寺拳法／合気道"
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.sizeToFit()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    private let stackView:UIStackView = {
        let stackView = UIStackView()
        let iv = UIImageView()
        iv.image = UIImage(systemName: "tag.fill")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .darkGray
        stackView.addSubview(iv)
        iv.anchor(top:stackView.topAnchor,
                  right: stackView.leftAnchor,
                  paddingTop: 5,
                  paddingRight: 3,
                  width: 20,
                  height: 20)
        return stackView
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(institutionNameLabel)
        addSubview(addressLabel)
        addSubview(competitionLabel)
        for tag in tagData {
            print(tag)
            let label = TagLabel(content: tag)
            stackView.addArrangedSubview(label)
        }
        stackView.distribution = .fill
        stackView.spacing = 5
        
        addSubview(stackView)
        institutionNameLabel.anchor(top:topAnchor,
                                    left: leftAnchor,
                                    right: rightAnchor)
        addressLabel.anchor(top: institutionNameLabel.bottomAnchor,
                            left: institutionNameLabel.leftAnchor,
                            right:rightAnchor,
                            paddingTop: 15,
                            paddingRight: 0,
                            paddingLeft: 25)
        competitionLabel.anchor(top: addressLabel.bottomAnchor,
                            left: institutionNameLabel.leftAnchor,
                            right: rightAnchor,paddingTop: 5,
                            paddingRight: 0,
                            paddingLeft: 25)
        stackView.anchor(top:competitionLabel.bottomAnchor,bottom:bottomAnchor,
                         left: institutionNameLabel.leftAnchor,
                         right: rightAnchor,
                         paddingTop: 15,paddingBottom: 80,
                         paddingRight: 10,
                         paddingLeft: 25)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}
