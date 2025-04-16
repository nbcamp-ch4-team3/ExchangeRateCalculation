import Foundation

class MainViewModel {
    private let service = DataService()
    private(set) var exchangeData = [String: Double]()
    private(set) var currencyCodes: [String] = []
    private(set) var currencyCountryInfo = CurrencyCountryInfo().infoList

    func fetchData() async throws {
        do {
            let exchangeData = try await service.fetchExchangeRateData()
            self.exchangeData = exchangeData.rates
            self.currencyCodes = exchangeData.rates.keys.sorted()
        } catch let error as APIError {
            throw error
        }
    }

}
