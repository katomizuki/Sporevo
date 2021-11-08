
import Foundation
import UIKit

class CustomHeaderFooterView: UITableViewHeaderFooterView {
    var section: Int = 0
    static let id = "CustomHeaderFooterView"
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
