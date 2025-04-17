//
//  CalculatorViewModel.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/16/25.
//

import Foundation

class CalculatorViewModel: ViewModelProtocol {
    let exchangeRate: ExchangeRate

    var action: ((Action) -> Void)?
    var state = State()

    enum Action {
        case calculate(input: String?)
    }

    struct State {
        var success: ((CalculationResult) -> Void)?
        var failure: ((CalculatorError) -> Void)?
    }

    init(exchangeRate: ExchangeRate) {
        self.exchangeRate = exchangeRate

        action = { action in
            switch action {
            case .calculate(let input):
                self.calculate(input: input)
            }
        }
    }

    private func calculate(input: String?) {
        guard let text = input, !text.isEmpty else {
            state.failure?(.inputIsEmpty)
            return
        }

        guard let amount = Double(text) else {
            state.failure?(.inputIsNotNumber(text))
            return
        }

        let result = CalculationResult(
            calculatedAmount: amount * exchangeRate.rate,
            currency: exchangeRate.currency
        )
        state.success?(result)
    }
}
