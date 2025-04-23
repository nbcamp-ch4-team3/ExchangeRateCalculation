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
    func saveLastScreen(screen: Screen, currency: String?) throws
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

    func saveLastScreen(screen: Screen, currency: String?) throws {
        do {
            let result = try viewContext.fetch(LastScreen.fetchRequest())
            if let existing = result.first {
                existing.screenName = screen.rawValue
                existing.currency = currency
            } else {
                let object = LastScreen(context: viewContext)
                object.screenName = screen.rawValue
                object.currency = currency
            }

            try viewContext.save()
        } catch {
            throw CoreDataError.saveError(error)
        }
    }
}
