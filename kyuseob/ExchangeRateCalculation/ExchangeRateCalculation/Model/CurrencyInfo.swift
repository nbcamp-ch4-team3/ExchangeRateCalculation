import Foundation

struct CurrencyInfo {
    let code: String
    let country: String
    let rate: Double

    var formattedRate: String {
        return String(format: "%.4f", rate)
    }
}
