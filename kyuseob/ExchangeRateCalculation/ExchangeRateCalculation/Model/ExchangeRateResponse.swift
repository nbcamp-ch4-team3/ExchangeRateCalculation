import Foundation

struct ExchangeRateResponse: Codable {
    let result: String
    let rates: [String : Double]
    let lastUpdatedDate: Date

    enum CodingKeys: String, CodingKey {
        case result = "result"
        case rates = "rates"
        case lastUpdatedDate = "time_last_update_utc"
    }
}
