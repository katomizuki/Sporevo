import Foundation
import UIKit

class InstitutionCell: UICollectionViewCell {
    static let id = "InstitutionCell"
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemPink
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}
