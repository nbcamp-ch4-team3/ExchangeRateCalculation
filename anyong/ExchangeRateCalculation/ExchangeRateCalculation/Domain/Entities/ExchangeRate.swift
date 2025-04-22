//
//  ExchangeRate.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/15/25.
//

import Foundation

struct ExchangeRate {
    let currencyCode: String
    let rate: Double
    let nation: String
    var isBookmark: Bool = false
    var fluctuationType: fluctuationType = .equal
}

enum fluctuationType {
    case up
    case down
    case equal
}
