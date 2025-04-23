//
//  CalculatorRepositoryProtocol.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/23/25.
//

import Foundation

protocol CalculatorRepositoryProtocol {
    func loadExchangeRate() -> ExchangeRate
    func calculate(input: String?) throws -> CalculationResult
}
