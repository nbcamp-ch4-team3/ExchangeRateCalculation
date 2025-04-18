//
//  ExchangeRateRepository.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/16/25.
//

import UIKit
import OSLog

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

    // NetworkService를 통해 환율 정보 받아오는 메서드
    func fetchExchangeRate() async throws -> ExchangeRates {
        let result = try await networkService.fetchExchangeRate()
        cachedExchangeRates = result.rates
            .map {
                ExchangeRate(currency: $0.key, rate: $0.value) // DTO를 Entity로 변환
            }
        return try syncExchangeRate() // CoreData에 저장된 즐겨찾기 목록 적용 후 업데이트
    }

    // 저장된 데이터 반환 메서드
    func loadExchangeRates() -> ExchangeRates {
        return cachedExchangeRates
    }

    // 검색어로 필터링한 데이터 반환 메서드
    func filterExchangeRates(with keyword: String) -> ExchangeRates {
        let uppercasedKeyword = keyword.uppercased() // Currency는 모두 대문자이므로 대문자로 변환

        return cachedExchangeRates.filter {
            $0.country.contains(uppercasedKeyword) || $0.currency.contains(uppercasedKeyword)
        }
    }

    // 즐겨찾기 추가 / 삭제 (CoreData) 메서드
    func toggleFavoriteItem(with currency: String) throws -> ExchangeRates {
        // 즐겨찾기에 추가인지 삭제인지를 구분하기 위해 isFavorite 프로퍼티를 찾음
        guard let isFavorite = cachedExchangeRates
            .first(where: {$0.currency == currency})?
            .isFavorite else {
            throw RepositoryError.itemNotFound(currency) // 데이터를 찾을 수 없으면 에러를 던짐
        }

        if isFavorite {
            try coreData.deleteData(currency: currency) // 즐겨찾기였던 경우 -> 삭제
        } else {
            try coreData.saveData(currency: currency) // 즐겨찾기가 아니었던 경우 -> 추가
        }
        return try syncExchangeRate() // CoreData에 저장된 즐겨찾기 목록 적용 후 업데이트
    }

    // CoreData에 저장된 즐겨찾기 목록 적용 후 업데이트
    private func syncExchangeRate() throws -> ExchangeRates {
        //TODO: cachedExchangeRates 즐겨찾기 순 정렬 (알파벳 오름차순 정렬)
        let favoriteItems = try coreData.readAllData()
        os_log(.debug, "CoreData에 저장된 모든 데이터\n%@", favoriteItems.joined(separator: ", "))

        // CoreData에 저장된 즐겨찾기 목록에 포함되는지 확인 후, 포함되면 isFavorite = true, 아니면 false
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
