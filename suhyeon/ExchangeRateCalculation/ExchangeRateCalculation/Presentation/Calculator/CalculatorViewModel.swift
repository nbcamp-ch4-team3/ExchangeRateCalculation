//
//  CalculatorViewModel.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/16/25.
//

import Foundation

final class CalculatorViewModel: ViewModelProtocol {
//    let exchangeRate: ExchangeRate
    private let useCase: CalculatorUseCaseProtocol

    var action: ((Action) -> Void)?
    var state = State()

    enum Action {
        case calculate(input: String?)
    }

    struct State {
        var exchangeRate: ExchangeRate?

        var success: ((CalculationResult) -> Void)?
        var failure: ((AppError) -> Void)?
    }

    init(useCase: CalculatorUseCaseProtocol) {
        self.useCase = useCase
        loadExchangeRate()

        action = {[weak self] action in
            guard let self else { return }

            switch action {
            case .calculate(let input):
                self.calculate(input: input)
            }
        }
    }

    private func loadExchangeRate() {
        state.exchangeRate = useCase.loadExchangeRate()
    }

    private func calculate(input: String?) {
        do {
            let result = try useCase.calculate(input: input)
            state.success?(result)
        } catch {
            state.failure?(AppError(error))
        }
    }
}
