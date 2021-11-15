//
//  TagLabel.swift
//  Sporevo
//
//  Created by ミズキ on 2021/11/09.
//

import Foundation
import UIKit
class TagLabel: UILabel {
    private var content:String
    private let padding:UIEdgeInsets = .zero
     init(content: String) {
         self.content = content
         super.init(frame: .zero)
         text = content
         font = .boldSystemFont(ofSize: 12)
         textColor = .white
         numberOfLines = 0
         sizeToFit()
         backgroundColor = .blue
         backgroundColor = .systemMint
         layer.masksToBounds = true
         layer.cornerRadius = 10
         textAlignment = .center
    }
    override var intrinsicContentSize: CGSize {
        var intrinsticContentSize = super.intrinsicContentSize
        intrinsticContentSize.height += padding.top + padding.bottom
        intrinsticContentSize.width += padding.left + padding.right
        return intrinsticContentSize
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
