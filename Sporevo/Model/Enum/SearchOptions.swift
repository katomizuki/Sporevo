import Foundation
import UIKit

// MARK: - SearchOptions
enum SearchOptions:Int,CaseIterable {
    case place
    case institution
    case competition
    case price
    case tag
    var description: String {
        switch self {
        case .place: return "所在地"
        case .institution: return "施設"
        case .competition: return "競技"
        case .price: return "料金"
        case .tag: return "タグ"
        }
    }
}
