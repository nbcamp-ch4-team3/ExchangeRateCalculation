import Foundation

class MainViewModel {
    private let service = DataService()
    private(set) var currencyItems: [CurrencyInfo] = []
    private(set) var filteredItems: [CurrencyInfo] = []
    private let currencyCountryInfo = CurrencyCountryInfo().infoList

    func fetchData() async throws {
        do {
            let exchangeData = try await service.fetchExchangeRateData()

            var items: [CurrencyInfo] = []
            for (code, rate) in exchangeData.rates {
                if let country = currencyCountryInfo[code] {
                    let item = CurrencyInfo(code: code, country: country, rate: rate)
                    items.append(item)
                }
            }

            self.currencyItems = items.sorted { $0.code < $1.code }
            self.filteredItems = self.currencyItems
        } catch let error as APIError {
            throw error
        }
    }

    func filterCurrencyItems(by searchText: String) {
        if !searchText.isEmpty {
            filteredItems = currencyItems.filter({ currencyInfo in
                currencyInfo.code.lowercased().contains(searchText.lowercased())
            })
        } else {
            filteredItems = currencyItems
        }
    }

}
