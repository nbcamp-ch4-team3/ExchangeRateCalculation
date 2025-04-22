import Foundation

final class MockDataService: DataServiceProtocol {
    func fetchExchangeRateData() async throws -> ExchangeRateResponse {
        let mockRates: [String: Double] = [
            "USD": 1.0,
            "KRW": 1422.09,
            "JPY": 141.75,
            "EUR": 0.87,
            "GBP": 0.75,
            "CNY": 7.29,
            "AUD": 1.56,
            "CAD": 1.38
        ]

        return ExchangeRateResponse(
            result: "success",
            rates: mockRates,
            lastUpdatedString: "Mon, 21 Apr 2025 00:02:31 +0000"
        )
    }
}
