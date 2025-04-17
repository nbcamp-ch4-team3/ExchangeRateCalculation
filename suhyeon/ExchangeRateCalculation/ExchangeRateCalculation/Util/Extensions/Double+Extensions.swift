//
//  Double+Extensions.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/17/25.
//

import Foundation

extension Double {
    func formatted(toDecimalDigits digits: Int) -> String {
        return String(format: "%.\(digits)f", self)
    }
}
