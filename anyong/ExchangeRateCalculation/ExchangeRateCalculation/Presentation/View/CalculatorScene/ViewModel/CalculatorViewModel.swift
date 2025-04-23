//
//  CalculatorViewModel.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/17/25.
//

import Foundation

final class CalculatorViewModel: ViewModelProtocol {
    var exchangeRate: ExchangeRate
    
    enum Action {
        case convert(input: String)
        case initialize
    }
    
    struct State {
        var result: String? = nil
        var currencyCode: String = ""
        var nation: String = ""
        var errorMessage: String? = nil
    }
            
    var action: ((Action) -> Void)?
    private(set) var state: State {
        didSet {
            onStateChanged?(state)
        }
    }
    var onStateChanged: ((State) -> Void)?
    
    
    init(exchangeRate: ExchangeRate) {
        self.exchangeRate = exchangeRate
        self.state = State()
        
        self.action = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case let .convert(input):
                self.convertHandle(input)
            case .initialize:
                self.initialHandle()
            }
        }
    }
    
    private func convertHandle(_ input: String) {
        guard !input.isEmpty else {
            state.errorMessage = "금액을 입력해주세요."
            return
        }

        guard let doubleValue = Double(input) else {
            state.errorMessage = "올바른 숫자를 입력해주세요"
            return
        }

        let converted = doubleValue * exchangeRate.rate
        let result = "$\(String(format: "%.2f", doubleValue)) → \(String(format: "%.2f", converted)) \(exchangeRate.currencyCode)"
        state.result = result
        state.errorMessage = nil
    }
    
    private func initialHandle() {
        state.currencyCode = exchangeRate.currencyCode
        state.nation = exchangeRate.nation
    }
}
