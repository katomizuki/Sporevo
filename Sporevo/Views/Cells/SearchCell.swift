import Foundation
import UIKit
protocol SeachCellDelegate:AnyObject {
    func searchCell(_ cell:SearchCell)
}
class SearchCell:UITableViewCell {
    // MARK: - Properties
    static let id = "SearchCell"
    weak var delegate: SeachCellDelegate?
    var searchButton:UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "plus.circle.fill")?.withRenderingMode(.alwaysTemplate)
        let imageview = UIImageView()
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        button.setImage(image, for: .normal)
        button.tintColor = .systemMint
        button.contentMode = .scaleToFill
        button.isUserInteractionEnabled = true
        button.isEnabled = true
        return button
    }()
    let elementLabel:UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    // MARK: - Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        contentView.addSubview(searchButton)
        searchButton.anchor(right:rightAnchor,
                            paddingRight: 20,
                            centerY:centerYAnchor,
                            width: 60,
                            height: 60)
        addSubview(elementLabel)
        elementLabel.anchor(top:topAnchor,bottom:bottomAnchor,left: leftAnchor,right: searchButton.leftAnchor,
                            paddingRight: 5,paddingLeft: 10,centerY: centerYAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func didTapSearchButton() {
        print(#function)
        self.delegate?.searchCell(self)
    }
}
