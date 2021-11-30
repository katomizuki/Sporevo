
import Foundation
import UIKit
class TagLabel: UILabel {
    private var content:String
    private let padding:UIEdgeInsets = .zero
     init(content: String) {
         self.content = content
         super.init(frame: .zero)
         text = " \(content) "
         font = .boldSystemFont(ofSize: 12)
         textColor = .white
         numberOfLines = 0
         sizeToFit()
         backgroundColor = .blue
         backgroundColor = .systemMint
         layer.masksToBounds = true
         layer.cornerRadius = 10
         textAlignment = .center
         preferredMaxLayoutWidth = 80
    }
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)))
    }
    override var intrinsicContentSize: CGSize {
        var intrinsticContentSize = super.intrinsicContentSize
        intrinsticContentSize.height += 10
        intrinsticContentSize.width += 10
        return intrinsticContentSize
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
