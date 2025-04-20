//
//  Currency.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/15/25.
//

import Foundation

struct Currency: Decodable {
    let code: String // 통화 코드(예: USD)
    let country: String // 통화 국가(예: 미국)
    let rate: Double // 환율(예: 1.000)
    var isFavorite: Bool = false
}

struct CurrencyResponse: Decodable {
    let rates: [String: Double] // 예: [USD: 1.0000]
}
