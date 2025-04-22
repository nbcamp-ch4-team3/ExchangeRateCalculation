import Foundation

protocol MainViewModelProtocol {
    var currencyItems: [CurrencyInfo] { get }
    var filteredItems: [CurrencyInfo] { get }

    func fetchData() async throws
    func filterCurrencyItems(by searchText: String)
    func resetFilteredItems()

    func fetchFavoriteCurrencies() throws
    func toggleFavorite(currencyCode: String) throws
    func isFavorite(currencyCode: String) -> Bool
}

final class MainViewModel: MainViewModelProtocol {
    private let service: DataServiceProtocol
    private(set) var currencyItems: [CurrencyInfo] = []
    private(set) var filteredItems: [CurrencyInfo] = []
    private let currencyCountryInfo = CurrencyCountryMap().infoList
    private var favoriteCurrencyCodes: Set<String> = []
    private let coreDataStack = CoreDataStack.shared

    init(service: DataServiceProtocol) {
        self.service = service
    }

    func fetchData() async throws {
        do {
            let prevCurrencies = try fetchPrevCurrencies()

            if let lastUpdated = prevCurrencies.first?.updatedDate {
                // 오늘 이미 업데이트 된 경우
                if isUpdatedToday(date: lastUpdated) {
                    currencyItems = convertEntityToModel(from: prevCurrencies)
                } else {
                    // 오늘 처음 업데이트 하는 경우
                    let exchangeData = try await service.fetchExchangeRateData()
                    currencyItems = compareAndConvertToModel(old: prevCurrencies, new: exchangeData.rates, updatedDate: exchangeData.lastUpdatedDate)
                }
            } else {
                // 처음 데이터를 불러오는 경우
                let exchangeData = try await service.fetchExchangeRateData()
                var items: [CurrencyInfo] = []
                for (code, rate) in exchangeData.rates {
                    if let country = currencyCountryInfo[code] {
                        let item = CurrencyInfo(code: code, country: country, rate: rate, trendString: "new", updatedDate: exchangeData.lastUpdatedDate)
                        items.append(item)
                    }
                }
                currencyItems = items
            }

            self.filteredItems = self.currencyItems
            sortItemsWithFavoritesOnTop()
            try saveCurrentCurrencies(with: currencyItems)
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

// MARK: - 즐겨찾기 Favorite 관련 메서드
extension MainViewModel {
    func fetchFavoriteCurrencies() throws {
        do {
            let favoriteEntities = try coreDataStack.fetchAllFavoriteCurrencies()
            favoriteCurrencyCodes.removeAll()
            favoriteEntities.forEach {
                guard let currencyCode = $0.currencyCode else { return }
                favoriteCurrencyCodes.insert(currencyCode)
            }
        } catch {
            throw error
        }
    }

    func addToFavorites(currencyCode: String) throws {
        if !favoriteCurrencyCodes.contains(currencyCode) {
            do {
                try coreDataStack.addFavorite(with: currencyCode)
                favoriteCurrencyCodes.insert(currencyCode)
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

// MARK: - Core Data에서 관리하는 Currency에 관한 메서드
extension MainViewModel {
    func fetchPrevCurrencies() throws -> [CurrencyEntity] {
        do {
            return try coreDataStack.fetchAllCurrencies()
        } catch {
            throw error
        }
    }

    func isUpdatedToday(date: Date) -> Bool {
        return Calendar.current.isDateInToday(date)
    }
}

// MARK: - CurrencyEntity, CurrencyInfo에 관한 메서드
extension MainViewModel {
    func convertEntityToModel(from: [CurrencyEntity]) -> [CurrencyInfo] { // 기존 코어 데이터 내 엔티티를 CurrencyInfo로 변환 (업데이트가 필요 없을 때)
        var currenciesInfo = [CurrencyInfo]()

        from.forEach { currencyEntity in
            let rate = currencyEntity.rate
            guard let code = currencyEntity.code,
                  let country = currencyEntity.country,
                  let trendString = currencyEntity.trend,
                  let updatedDate = currencyEntity.updatedDate else { return }
            let currencyInfo = CurrencyInfo(code: code, country: country, rate: rate, trendString: trendString, updatedDate: updatedDate)
            currenciesInfo.append(currencyInfo)
        }

        return currenciesInfo
    }

    // 새롭게 받아온 데이터를 기준으로 기존 데이터 비교해 업데이트 및 변환
    func compareAndConvertToModel(old: [CurrencyEntity], new: [String: Double], updatedDate: Date) -> [CurrencyInfo] {
        var result = [CurrencyInfo]()

        old.forEach { oldEntity in // 기존에 있던 통화에 대한 처리
            guard let code = oldEntity.code, let country = oldEntity.country else { return }

            if let newRate = new[code] {
                let trendString: String
                if oldEntity.rate > newRate { trendString = "down" }
                else if oldEntity.rate < newRate { trendString = "up" }
                else { trendString = "unchanged" }

                let info = CurrencyInfo(code: code, country: country, rate: newRate, trendString: trendString, updatedDate: updatedDate)
                result.append(info)
            }
        }

        for (code, rate) in new {
            if !old.contains(where: { $0.code == code }) {
                if let country = currencyCountryInfo[code] {
                    let info = CurrencyInfo(code: code, country: country, rate: rate, trendString: "new", updatedDate: updatedDate)
                    result.append(info)
                }
            }
        }

        return result
    }

    func saveCurrentCurrencies(with currencyInfos: [CurrencyInfo]) throws {
        do {
            // 기존 데이터 모두 삭제
            try coreDataStack.deleteAllCurrencies()

            // 새 데이터 추가
            for currencyInfo in currencyInfos {
                try coreDataStack.addCurrency(
                    code: currencyInfo.code,
                    country: currencyInfo.country,
                    rate: currencyInfo.rate,
                    trend: currencyInfo.trendString,
                    updatedDate: currencyInfo.updatedDate
                )
            }
        } catch {
            throw error
        }
    }

}
