//
//  CalculatorRepository.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/23/25.
//

import Foundation

final class CalculatorRepository: CalculatorRepositoryProtocol {
    private let exchangeRate: ExchangeRate

    init(exchangeRate: ExchangeRate) {
        self.exchangeRate = exchangeRate
    }

    func loadExchangeRate() -> ExchangeRate {
        return exchangeRate
    }

    func calculate(input: String?) throws -> CalculationResult {
        guard let text = input, !text.isEmpty else {
            throw CalculatorError.inputIsEmpty
        }

        guard let amount = Double(text) else {
            throw CalculatorError.inputIsNotNumber(text)
        }

        return CalculationResult(
            calculatedAmount: amount * exchangeRate.rate,
            currency: exchangeRate.currency
        )
    }
}
