//
//  DetailViewModel.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/18/25.
//

import Foundation

protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output
    
    var input: ((Input) -> Void)? { get }
    var output: Output { get }
}

final class DetailViewModel: ViewModelProtocol {
    enum ValidationResult {
        case valid(result: String)
        case invalid(message: String)
    }
    
    enum Input {
        case validate(String?)
    }
    
    typealias Output = (ValidationResult) -> Void
    
    let currency: Currency
    var input: ((Input) -> Void)?
    var output: Output = { _ in }
    
    init(currency: Currency) {
        self.currency = currency
        
        input = { input in
            switch input {
            case .validate(let text):
                self.validate(text)
            }
        }
    }
    
    // 텍스트 필드 사용자 입력값 검증
    private func validate(_ input: String?) {
        guard let input else { return }
        
        // 입력값이 없을 때
        if input.isEmpty {
            output(.invalid(message: "금액을 입력해주세요."))
            return
        }
        
        // 입력값이 있을 때
        if let number = Double(input) {
            // 입력값 정상
            let result = "$\(input) → \(String(format: "%.2f", number * currency.rate)) \(currency.code)"
            output(.valid(result: result))
        } else {
            // 입력값이 숫자가 아닐 때
            output(.invalid(message: "올바른 숫자를 입력해주세요."))
        }
    }
}
