import Foundation
import UIKit
class ComepetionView:UIView {
    var title:String
    var image:UIImage
    init(title: String,image:UIImage) {
        self.title = title
        self.image = image
        super.init(frame: .zero)
        let label = UILabel()
        let iv = UIImageView()
        iv.image = image
        label.text = title
        addSubview(label)
        addSubview(iv)
        iv.anchor(left:leftAnchor,paddingLeft: 5,centerY: centerYAnchor)
        label.anchor(left:iv.rightAnchor,paddingLeft: 5,centerY: centerYAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
