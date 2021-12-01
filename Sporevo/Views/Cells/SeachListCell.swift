import Foundation
import UIKit

class SearchListCell:UITableViewCell {
    static let id = "SearchListCell"
    let label:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        let view = UIView()
//        view.backgroundColor = .white
//        view.addSubview(label)
//        addSubview(view)
//        view.anchor(top:topAnchor,bottom: bottomAnchor,left: leftAnchor,right: rightAnchor)
//        label.anchor(left:view.leftAnchor,paddingLeft: 40,centerY: view.centerYAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    override func prepareForReuse() {
//        backgroundColor = .clear
//        accessoryType = .none
//    }
  
}
