import Foundation

struct ExchangeRateResponse: Codable {
    let result: String
    let rates: [String : Double]
}
