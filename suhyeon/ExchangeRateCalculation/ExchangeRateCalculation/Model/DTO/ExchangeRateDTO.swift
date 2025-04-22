//
//  ExchangeRateDTO.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/14/25.
//

import Foundation

struct ExchangeRateDTO: Codable {
    let result: String
    let nextUpdateTime: Date
    let rates: [String: Double]

    enum CodingKeys: String, CodingKey {
        case result
        case nextUpdateTime = "time_next_update_unix"
        case rates
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.result = try container.decode(String.self, forKey: .result)
        let nextUpdateTimeUnix = try container.decode(Int.self, forKey: .nextUpdateTime)
        self.nextUpdateTime = Date(timeIntervalSince1970: TimeInterval(nextUpdateTimeUnix))
        self.rates = try container.decode([String : Double].self, forKey: .rates)
    }
}
