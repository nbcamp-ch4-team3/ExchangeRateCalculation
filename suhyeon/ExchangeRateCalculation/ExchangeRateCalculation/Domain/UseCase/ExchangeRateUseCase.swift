//
//  ExchangeRateUseCase.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/23/25.
//

import Foundation

protocol ExchangeRateUseCaseProtocol {
    func exchangeRate(with currency: String) throws -> ExchangeRate
    func fetchExchangeRates() async throws -> ExchangeRates
    func loadExchangeRates() -> ExchangeRates
    func filterExchangeRates(with keyword: String) -> ExchangeRates
    func toggleFavoriteItem(with currency: String) throws -> ExchangeRates
}

final class ExchangeRateUseCase: ExchangeRateUseCaseProtocol {

    private let repository: ExchangeRateRepository

    init(repository: ExchangeRateRepository) {
        self.repository = repository
    }

    func exchangeRate(with currency: String) throws -> ExchangeRate {
        try repository.exchangeRate(with: currency)
    }

    func fetchExchangeRates() async throws -> ExchangeRates {
        try await repository.fetchExchangeRates()
    }

    func loadExchangeRates() -> ExchangeRates {
        repository.loadExchangeRates()
    }

    func filterExchangeRates(with keyword: String) -> ExchangeRates {
        repository.filterExchangeRates(with: keyword)
    }

    func toggleFavoriteItem(with currency: String) throws -> ExchangeRates {
        try repository.toggleFavoriteItem(with: currency)
    }
}
