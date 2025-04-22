import Foundation

struct ExchangeRateResponse: Codable {
    let result: String
    let rates: [String : Double]
    let lastUpdatedString: String
    var lastUpdatedDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"

        return dateFormatter.date(from: lastUpdatedString) ?? Date()
    }

    enum CodingKeys: String, CodingKey {
        case result = "result"
        case rates = "rates"
        case lastUpdatedString = "time_last_update_utc"
    }
}
