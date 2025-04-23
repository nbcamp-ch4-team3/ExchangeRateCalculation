//
//  LastScreenRepositoryProtocol.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/23/25.
//

import Foundation

protocol LastScreenRepositoryProtocol {
    func readLastScreen() throws -> LastScreen?
    func saveLastScreen(screen: Screen, exchangeRate: ExchangeRate?) throws
}
