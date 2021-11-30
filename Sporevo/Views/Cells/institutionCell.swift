import Foundation
import UIKit

class InstitutionCell: UICollectionViewCell {
    static let id = "InstitutionCell"
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
//    private let tagImage:UIImageView = {
//        let iv = UIImageView()
//        iv.image = UIImage(systemName: "tag.fill")?.withRenderingMode(.alwaysTemplate)
//        iv.tintColor = .darkGray
//        return iv
//    }()
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        layout.minimumInteritemSpacing = 5
//        layout.minimumLineSpacing = 5
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.contentMode = .left
        cv.register(TagCell.self, forCellWithReuseIdentifier: TagCell.id)
        
        return cv
    }()
    private var tags = [String]()    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(institutionNameLabel)
        addSubview(addressLabel)
        addSubview(competitionLabel)
        let view = UIView()
        addSubview(view)
//        addSubview(tagImage)
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
        view.addSubview(collectionView)
        collectionView.anchor(top:view.topAnchor,bottom: view.bottomAnchor,
                              left: view.leftAnchor,right: view.rightAnchor)
        view.anchor(top:competitionLabel.bottomAnchor,bottom:bottomAnchor,
                         left: institutionNameLabel.leftAnchor,
                         right: rightAnchor,paddingTop: 20,
                         paddingRight: 10,
                         paddingLeft: 25)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    func configure(facility:Facility) {
        institutionNameLabel.text = " \(facility.name) "
        addressLabel.text = facility.address
        var message = String()
        facility.sports_types.forEach {
            message += "\($0)/"
        }
        message = String(message.dropLast())
        competitionLabel.text = message
        tags = facility.tags
        collectionView.reloadData()
    }
}

extension InstitutionCell:UICollectionViewDelegate {
    
}
extension InstitutionCell:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.id, for: indexPath) as? TagCell else { fatalError("can't make TagCell") }
        cell.tagLabel.text = "# \(tags[indexPath.row])"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
}



