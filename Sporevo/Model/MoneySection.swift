import Foundation
struct MoneySection {
    let units:MoneyUnits
    let prices:[PriceUnits]
    var isOpened = false
    init(units:MoneyUnits,prices:[PriceUnits],isOpened:Bool = false) {
        self.units = units
        self.prices = prices
        self.isOpened = isOpened
    }
}

