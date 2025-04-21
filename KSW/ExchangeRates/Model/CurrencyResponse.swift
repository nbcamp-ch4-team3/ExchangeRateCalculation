//
//  CurrencyResponse.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/15/25.
//

import Foundation

struct CurrencyResponse: Decodable {
    let rates: [String: Double] // 예: [USD: 1.0000]
}
