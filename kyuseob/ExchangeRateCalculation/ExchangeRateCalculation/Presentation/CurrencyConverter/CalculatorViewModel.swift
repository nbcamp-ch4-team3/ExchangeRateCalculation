import Foundation

protocol CalculatorViewModelProtocol {
    var currencyInfo: CurrencyInfo? { get }

    func setCurrencyInfo(to: CurrencyInfo)
    func convert(from: Double) -> Double
}

class CalculatorViewModel: CalculatorViewModelProtocol {
    private(set) var currencyInfo: CurrencyInfo? = nil

    func setCurrencyInfo(to: CurrencyInfo) {
        currencyInfo = to
    }

    func convert(from: Double) -> Double {
        guard let currencyInfo else { return 0.00 }
        return from * currencyInfo.rate
    }
}
