//
//  CalculatorError.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/17/25.
//

import Foundation

enum CalculatorError: AppErrorProtocol {
    case inputIsNotNumber(String)
    case inputIsEmpty
}

extension CalculatorError {
    var errorDescription: String? {
        switch self {
        case .inputIsNotNumber:
            "올바른 숫자를 입력해주세요"
        case .inputIsEmpty:
            "금액을 입력해주세요"
        }
    }

    var debugDescription: String {
        switch self {
        case .inputIsNotNumber(let string):
            "CalculatorError - 입력된 데이터: \(string)"
        case .inputIsEmpty:
            "CalculatorError - 금액을 입력하지 않았습니다"
        }
    }
}
