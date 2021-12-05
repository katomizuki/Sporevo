import Foundation
import UIKit

class SearchListCell:UITableViewCell {
    static let id = "SearchListCell"
    let sectionImageView :UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.forward")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .darkGray
        iv.isHidden = true
        return iv
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(sectionImageView)
        sectionImageView.anchor(right:rightAnchor, paddingRight: 20,centerY:centerYAnchor,width: 20,height: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        backgroundColor = .clear
        sectionImageView.isHidden = true
//        accessoryType = .none
    }
  
}
