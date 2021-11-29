import Foundation
import UIKit

final class TagCell:UICollectionViewCell {
    static let id = String(describing: type(of: self))
    let tagLabel = TagLabel(content: "アイウエオfafafafafafafafaf")
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(tagLabel)
        tagLabel.anchor(top:topAnchor,bottom: bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop: 0,paddingBottom: 0,
                        paddingRight: 0,paddingLeft: 0,centerX:centerXAnchor,centerY:centerYAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
