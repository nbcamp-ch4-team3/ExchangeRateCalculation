//
//  ExchangeRateResponse.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/15/25.
//

import Foundation

struct ExchangeRateResponse: Codable {
    let rates: [String: Double]
}
