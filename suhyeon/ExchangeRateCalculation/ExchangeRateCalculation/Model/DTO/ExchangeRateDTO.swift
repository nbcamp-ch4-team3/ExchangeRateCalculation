//
//  ExchangeRateDTO.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/14/25.
//

import Foundation

struct ExchangeRateDTO: Codable {
    let result: String
    let rates: [String: Double]
}
