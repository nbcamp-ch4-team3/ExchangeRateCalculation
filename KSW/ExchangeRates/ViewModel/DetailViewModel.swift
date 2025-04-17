//
//  DetailViewModel.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/18/25.
//

import Foundation

enum ValidationResult {
    case valid(number: Double)
    case invalid(message: String)
}

class DetailViewModel {
    let currency: Currency
    
    var onValidate: (ValidationResult) -> Void = { _ in }
    
    init(currency: Currency) {
        self.currency = currency
    }
    
    // 텍스트 필드 사용자 입력값 검증
    func validate(_ text: String?) {
        guard let text else { return }
        
        // 입력값이 없을 때
        if text.isEmpty {
            onValidate(.invalid(message: "금액을 입력해주세요."))
            return
        }
        
        // 입력값이 있을 때
        if let number = Double(text) {
            // 입력값 정상
            onValidate(.valid(number: number))
        } else {
            // 입력값이 숫자가 아닐 때
            onValidate(.invalid(message: "올바른 숫자를 입력해주세요."))
        }
    }
}
