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
    private let coreData: ExchangeRateCoreData

    private var cachedExchangeRates = ExchangeRates()

    private init() {
        //TODO: 클린 아키텍처로 리팩토링 시 import UIKit 제거
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.coreData = ExchangeRateCoreData(container: appDelegate.persistentContainer)
//        coreData.saveMockData()
    }

    // NetworkService를 통해 환율 정보 받아오는 메서드
    func fetchExchangeRate() async throws -> ExchangeRates {
        // TODO: updateDate를 받아와서 현재 시간이랑 비교 후 안 지났으면 캐시 데이터, 지났으면 패치
        let nextUpdateDate = try coreData.readNextUpdateDate()
        // 저장된 데이터가 있고, updateDate가 지나지 않은 경우, 저장된 데이터 반환
        if let nextUpdateDate = nextUpdateDate {
            if nextUpdateDate > Date() {
                os_log("nextUpdateDate가 지나지 않아, 기존 데이터 사용", type: .debug)
                try fetchCachedExchangeRates()
            } else {
                os_log("nextUpdateDate가 지나, 새로 데이터 가져오기", type: .debug)
                let result = try await networkService.fetchExchangeRate()
                let prevData = try coreData.readAllData()
                // 지난 rate와 비교
                cachedExchangeRates = result.rates
                    .compactMap { (currency, rate) in
                        guard let prevRate = prevData.first(where: { $0.currency == currency })?.rate else {
                            print("\(currency) nil")
                            return nil
                        }
                        return ExchangeRate(currency: currency, rate: rate, fluctuation: Fluctuation(prevRate: prevRate, rate: rate)) // DTO를 Entity로 변환
                    }
                // CoreData에 update
                for exchangeRate in cachedExchangeRates {
                    try coreData.updateData(data: exchangeRate, nextUpdateDate: result.nextUpdateTime)
                }
            }
        } else { // 저장된 데이터가 없는 경우 mock 데이터 저장
            os_log("MockData 저장", type: .debug)
            coreData.saveMockData()
            try fetchCachedExchangeRates()
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
        try coreData.updateIsFavorite(currency: currency)
        return try syncExchangeRate() // CoreData에 저장된 즐겨찾기 목록 적용 후 업데이트
    }

    // CoreData에 저장된 데이터를 cachedExchangeRates에 저장
    private func fetchCachedExchangeRates() throws {
        cachedExchangeRates = try coreData.readAllData()
            .map {
                ExchangeRate(
                    currency: $0.currency,
                    rate: $0.rate,
                    fluctuation: Fluctuation(fluctuation: $0.fluctuation),
                    isFavorite: $0.isFavorite
                )
            }
    }

    // CoreData에 저장된 즐겨찾기 목록 적용 후 업데이트
    private func syncExchangeRate() throws -> ExchangeRates {
        //TODO: cachedExchangeRates 즐겨찾기 순 정렬 (알파벳 오름차순 정렬)
        let favoriteItems = try coreData.readAllData()
            .filter({ $0.isFavorite })
            .map{ $0.currency }

        // CoreData에 저장된 즐겨찾기 목록에 포함되는지 확인 후, 포함되면 isFavorite = true, 아니면 false
        cachedExchangeRates = cachedExchangeRates
            .map {
                var newItem = $0
                newItem.setIsFavorite(
                    isFavorite: favoriteItems.contains($0.currency)
                )
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
