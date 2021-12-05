import Foundation
import UIKit
class MenuOptionsCell:UITableViewCell {
    static let id = "MenuOptionsCell"
    var iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.tintColor = .white
        return iv
    }()
    var desciptionLabel:UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "text"
        label.textColor = .white
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemMint
        addSubview(iconImageView)
        addSubview(desciptionLabel)
        iconImageView.anchor(left:leftAnchor,
                             paddingLeft: 12,
                             centerY: centerYAnchor,
                             width: 36,
                             height: 36)
        addSubview(desciptionLabel)
 
        desciptionLabel.anchor(left:iconImageView.rightAnchor,
                               paddingLeft:12,
                               centerY:centerYAnchor)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}
