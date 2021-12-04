
import Foundation
struct CitySection {
    let pre:Prefecture
    let items:[City]
    var isOpened = false
    init(pre:Prefecture,items:[City],isOpened:Bool = false) {
        self.pre = pre
        self.items = items
        self.isOpened = isOpened
    }
}
