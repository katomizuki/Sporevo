//
//  InstitutionHeader.swift
//  Sporevo
//
//  Created by ミズキ on 2021/11/09.
//

import Foundation
import UIKit
class InsitutionHeader: UIView {
    var title:String
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 1
        let label = UILabel()
        label.text = "  \(title)"
        label.font = .systemFont(ofSize: 20, weight: .black)
        label.textColor = .darkGray
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 2
        layer.masksToBounds = true
        addSubview(label)
        label.anchor(left: leftAnchor,paddingLeft: 10,centerY: centerYAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
