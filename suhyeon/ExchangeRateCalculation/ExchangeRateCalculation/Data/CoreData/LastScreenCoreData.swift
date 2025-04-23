//
//  LastScreenCoreData.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/22/25.
//

import Foundation
import CoreData

enum Screen: String {
    case main
    case calculator
}

protocol LastScreenCoreDataProtocol {
    func readLastScreen() throws -> LastScreen?
    func saveLastScreen(screen: Screen, exchangeRate: ExchangeRate?) throws
}

final class LastScreenCoreData: LastScreenCoreDataProtocol {
    private let container: NSPersistentContainer
    private let viewContext: NSManagedObjectContext

    init(container: NSPersistentContainer) {
        self.container = container
        self.viewContext = container.viewContext
    }

    func readLastScreen() throws -> LastScreen? {
        do {
            let result = try viewContext.fetch(LastScreen.fetchRequest())
            return result.first
        } catch {
            throw CoreDataError.readError(error)
        }
    }

    func saveLastScreen(screen: Screen, exchangeRate: ExchangeRate?) throws {
        do {
            let lastScreen = try viewContext.fetch(LastScreen.fetchRequest())
                .first ?? LastScreen(context: viewContext)
            lastScreen.screenName = screen.rawValue

            if let exchangeRate {
                 let cdRate = lastScreen.cdExchangeRate ?? CDExchangeRate(context: viewContext)
                 cdRate.currency = exchangeRate.currency
                 cdRate.fluctuation = exchangeRate.fluctuation.rawValue
                 cdRate.isFavorite = exchangeRate.isFavorite
                 cdRate.rate = exchangeRate.rate
                 cdRate.nextUpdateDate = Date()
                 lastScreen.cdExchangeRate = cdRate
             }

            try viewContext.save()
        } catch {
            throw CoreDataError.saveError(error)
        }
    }
}
