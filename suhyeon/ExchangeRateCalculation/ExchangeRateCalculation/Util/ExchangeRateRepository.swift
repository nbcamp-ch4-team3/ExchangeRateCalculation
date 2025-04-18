//
//  ExchangeRateRepository.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/16/25.
//

import UIKit

final class ExchangeRateRepository {
    // 환율 정보, 환율 계산 VC에서 사용하므로 데이터 무결성을 위해 싱글턴 패턴 사용
    static let shared = ExchangeRateRepository()

    private let networkService = NetworkService()
    private let coreData: CurrencyCoreData

    private var cachedExchangeRates = ExchangeRates()

    private init() {
        //TODO: 클린 아키텍처로 리팩토링 시 import UIKit 제거
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.coreData = CurrencyCoreData(container: appDelegate.persistentContainer)
    }

    func fetchExchangeRate() async throws -> ExchangeRates {
        let result = try await networkService.fetchExchangeRate()
        cachedExchangeRates = result.rates
            .map {
                ExchangeRate(currency: $0.key, rate: $0.value)
            }
        return try syncExchangeRate()
    }

    func loadExchangeRates() -> ExchangeRates {
        return cachedExchangeRates
    }

    func filterExchangeRates(with keyword: String) -> ExchangeRates {
        let uppercasedKeyword = keyword.uppercased()

        return cachedExchangeRates.filter {
            $0.country.contains(uppercasedKeyword) || $0.currency.contains(uppercasedKeyword)
        }
    }

    func toggleFavoriteItem(with currency: String) throws -> ExchangeRates {
        //TODO: coreData에 추가 / 삭제
        guard let isFavorite = cachedExchangeRates
            .first(where: {$0.currency == currency})?
            .isFavorite else {
            throw RepositoryError.itemNotFound(currency)
        }

        if isFavorite {
            try coreData.deleteData(currency: currency)
        } else {
            try coreData.saveData(currency: currency)
        }
        return try syncExchangeRate()
    }

    private func syncExchangeRate() throws -> ExchangeRates {
        //TODO: cachedExchangeRates 즐겨찾기 순 정렬 (알파벳 오름차순 정렬)
        let favoriteItems = try coreData.readAllData()
        print(favoriteItems)

        cachedExchangeRates = cachedExchangeRates
            .map {
                var newItem = $0
                newItem.setIsFavorite(isFavorite: favoriteItems.contains($0.currency))
                return newItem
            }
            .sorted {
                if $0.isFavorite != $1.isFavorite {
                    return $0.isFavorite && !$1.isFavorite
                }
                return $0.currency < $1.currency
            }
        return cachedExchangeRates
    }
}
