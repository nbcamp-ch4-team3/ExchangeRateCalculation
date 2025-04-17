//
//  Currency.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/15/25.
//

import Foundation

struct Currency: Decodable {
    let code: String
    let country: String
    let rate: Double
}

struct CurrencyResponse: Decodable {
    let rates: [String: Double] // 예: [USD: 1.0000]
}
