
import Foundation
import UIKit
enum MenuOptions:Int,CaseIterable {
    case profile
    case search
    case settings
    case info
    var description:String {
        switch self {
        case .profile: return "ユーザー"
        case .search: return "条件検索"
        case .settings: return "設定"
        case .info: return "問い合わせ"
        }
    }
    var icon: UIImage? {
        switch self {
        case .profile: return UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysTemplate)
        case .search: return UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        case .settings: return UIImage(systemName: "gearshape.fill")?.withRenderingMode(.alwaysTemplate)
        case .info: return UIImage(systemName: "info.circle.fill")?.withRenderingMode(.alwaysTemplate)
        }
    }
}
