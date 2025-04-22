//
//  CurrencyResponse.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/15/25.
//

import Foundation

struct CurrencyResponse: Decodable {
    let timestamp: TimeInterval // 업데이트 일시
    let rates: [String: Double] // 예: [USD: 1.0000]
    
    enum CodingKeys: String, CodingKey {
        case timestamp = "time_last_update_unix"
        case rates
    }
}
