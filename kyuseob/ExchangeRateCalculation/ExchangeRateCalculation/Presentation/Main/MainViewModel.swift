import Foundation

protocol MainViewModelProtocol {
    var currencyItems: [CurrencyInfo] { get }
    var filteredItems: [CurrencyInfo] { get }

    func fetchData() async throws
    func filterCurrencyItems(by searchText: String)
    func resetFilteredItems()

    func fetchFavoriteCurrencies() throws
    func addToFavorites(currencyCode: String) throws
    func removeFromFavorites(currencyCode: String) throws
    func toggleFavorite(currencyCode: String) throws
    func isFavorite(currencyCode: String) -> Bool
}

class MainViewModel: MainViewModelProtocol {
    private let service: DataServiceProtocol
    private(set) var currencyItems: [CurrencyInfo] = []
    private(set) var filteredItems: [CurrencyInfo] = []
    private let currencyCountryInfo = CurrencyCountryMap().infoList
    private var favoriteCurrencyCodes = [String]()
    private let coreDataStack = CoreDataStack.shared

    init(service: DataServiceProtocol = DataService()) {
        self.service = service
    }

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
            sortItemsWithFavoritesOnTop()
        } catch {
            throw error
        }
    }

    func filterCurrencyItems(by searchText: String) {
        if !searchText.isEmpty {
            let uppercasedSearchText = searchText.uppercased()
            filteredItems = currencyItems.filter({ currencyInfo in
                currencyInfo.code.uppercased().contains(uppercasedSearchText) || currencyInfo.country.uppercased().contains(uppercasedSearchText)
            })
        } else {
            filteredItems = currencyItems
        }
        sortItemsWithFavoritesOnTop()
    }

    func resetFilteredItems() {
        filteredItems = currencyItems
    }

}

extension MainViewModel {
    func fetchFavoriteCurrencies() throws {
        do {
            let favoriteEntities = try coreDataStack.fetchAllFavoriteCurrencies()
            favoriteCurrencyCodes.removeAll()
            favoriteEntities.forEach {
                guard let currencyCode = $0.currencyCode else { return }
                favoriteCurrencyCodes.append(currencyCode)
            }
        } catch {
            throw error
        }
    }

    func addToFavorites(currencyCode: String) throws {
        if !favoriteCurrencyCodes.contains(currencyCode) {
            do {
                try coreDataStack.addFavorite(with: currencyCode)
                favoriteCurrencyCodes.append(currencyCode)
            } catch {
                throw error
            }
        }
    }

    func removeFromFavorites(currencyCode: String) throws {
        do {
            try coreDataStack.removeFavorite(with: currencyCode)
            if let index = favoriteCurrencyCodes.firstIndex(of: currencyCode) {
                favoriteCurrencyCodes.remove(at: index)
            }
        } catch {
            throw error
        }
    }

    func toggleFavorite(currencyCode: String) throws {
        if isFavorite(currencyCode: currencyCode) {
            try removeFromFavorites(currencyCode: currencyCode)
        } else {
            try addToFavorites(currencyCode: currencyCode)
        }
        sortItemsWithFavoritesOnTop()
    }

    func isFavorite(currencyCode: String) -> Bool {
        return favoriteCurrencyCodes.contains(currencyCode)
    }

    func sortItemsWithFavoritesOnTop() {
        filteredItems.sort { item1, item2 in
            let isFavorite1 = isFavorite(currencyCode: item1.code)
            let isFavorite2 = isFavorite(currencyCode: item2.code)

            if isFavorite1 == isFavorite2 { // 즐겨찾기 여부가 같은 경우 code 알파벳 순으로 정렬
                return item1.code < item2.code
            }

            return isFavorite1 && !isFavorite2
        }
    }
}
