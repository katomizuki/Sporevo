
import Foundation
import UIKit

class MainHeaderView:UIImageView {
    // MARK: - Propertis
    private let titleView:UIView = {
       let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    // MARK: Initialize
    override init(image: UIImage?) {
        super.init(image: image)
        addSubview(titleView)
        titleView.anchor(bottom:bottomAnchor,
                         paddingBottom: 50,
                         centerX:centerXAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
