//
//  CalculatorUseCase.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/23/25.
//

import Foundation

protocol CalculatorUseCaseProtocol {
    func loadExchangeRate() -> ExchangeRate
    func calculate(input: String?) throws -> CalculationResult
}

final class CalculatorUseCase: CalculatorUseCaseProtocol {
    private let repository: CalculatorRepositoryProtocol

    init(repository: CalculatorRepositoryProtocol) {
        self.repository = repository
    }

    func loadExchangeRate() -> ExchangeRate {
        repository.loadExchangeRate()
    }

    func calculate(input: String?) throws -> CalculationResult {
        try repository.calculate(input: input)
    }
}
