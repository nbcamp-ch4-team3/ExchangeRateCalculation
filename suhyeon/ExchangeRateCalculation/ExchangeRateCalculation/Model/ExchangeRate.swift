//
//  ExchangeRate.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/15/25.
//

import Foundation

struct ExchangeRate {
    let country: String
    let currency: String
    let rate: Double
}

typealias ExchangeRates = [ExchangeRate]
