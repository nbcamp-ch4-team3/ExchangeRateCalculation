//
//  ExchangeRateRepositoryProtocol.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/23/25.
//

import Foundation

protocol ExchangeRateRepositoryProtocol {
    func exchangeRate(with currency: String) throws -> ExchangeRate
    func fetchExchangeRates() async throws -> ExchangeRates
    func loadExchangeRates() -> ExchangeRates
    func filterExchangeRates(with keyword: String) -> ExchangeRates
    func toggleFavoriteItem(with currency: String) throws -> ExchangeRates
}
