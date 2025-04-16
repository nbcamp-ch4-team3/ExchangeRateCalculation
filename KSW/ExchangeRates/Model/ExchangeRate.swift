//
//  ExchangeRate.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/15/25.
//

import Foundation

struct ExchangeRate: Decodable {
    let code: String
    let country: String
    let rate: Double
}

struct ExchangeRateResponse: Decodable {
    let rates: [String: Double] // 예: [USD: 1.0000]
}
