import Foundation

class CalculatorViewModel {
    private(set) var currencyInfo: CurrencyInfo? = nil

    func setCurrencyInfo(to: CurrencyInfo) {
        currencyInfo = to
    }

    func convert(from: Double) -> Double {
        guard let currencyInfo else { return 0.00 }
        return from * currencyInfo.rate
    }
}
