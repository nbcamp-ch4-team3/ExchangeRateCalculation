//
//  LastScreenRepository.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/22/25.
//

import Foundation
import CoreData

final class LastScreenRepository {
    private let coreData: LastScreenCoreData

    init(coreData: LastScreenCoreData) {
        self.coreData = coreData
    }

    func readLastScreen() throws -> LastScreen? {
        return try coreData.readLastScreen()
    }

    func saveLastScreen(screen: Screen, currency: String?) throws {
        return try coreData.saveLastScreen(screen: screen, currency: currency)
    }
}
