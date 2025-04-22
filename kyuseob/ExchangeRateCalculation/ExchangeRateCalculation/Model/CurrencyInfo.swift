import Foundation

struct CurrencyInfo {
    let code: String
    let country: String
    let rate: Double
    let trendString: String
    let updatedDate: Date

    var formattedRate: String {
        return String(format: "%.4f", rate)
    }

    var trend: TrendDirection {
        switch trendString {
        case "up":
            return .up
        case "down":
            return .down
        case "unchanged":
            return .unchanged
        case "new":
            return .new
        default:
            return .new
        }
    }

    init(code: String, country: String, rate: Double, trendString: String, updatedDate: Date) {
        self.code = code
        self.country = country
        self.rate = rate
        self.trendString = trendString
        self.updatedDate = updatedDate
    }
}

enum TrendDirection {
    case up, down, unchanged, new
}
