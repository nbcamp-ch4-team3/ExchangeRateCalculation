//
//  CurrencyCoreData.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/17/25.
//

import UIKit
import CoreData

final class CurrencyCoreData {
    private var container: NSPersistentContainer

    init(container: NSPersistentContainer) {
        self.container = container
    }

    func readAllData() throws -> [String] {
        let viewContext = container.viewContext

        do {
            let result = try viewContext.fetch(Currency.fetchRequest())
            return result.compactMap { $0.currency }
        } catch {
            throw CoreDataError.readError(error)
        }
    }

    func saveData(currency: String) throws {
        let viewContext = container.viewContext
        let currencyObject = Currency(context: viewContext) // Currency 객체 생성 및 viewContext에 등록
        currencyObject.currency = currency // 객체의 속성 할당

        do {
            try viewContext.save()
        } catch {
            throw CoreDataError.saveError(error)
        }
    }

    func deleteData(currency: String) throws {
        let fetchRequest: NSFetchRequest<Currency> = Currency.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "currency == %@", currency)

        do {
            let result = try container.viewContext.fetch(fetchRequest)
            result.forEach { container.viewContext.delete($0) }
            try container.viewContext.save()
        } catch {
            throw CoreDataError.deleteError(error)
        }
    }

    func deleteAllData() throws {
        let fetchRequest: NSFetchRequest<Currency> = Currency.fetchRequest()

        do {
            let result = try container.viewContext.fetch(fetchRequest)
            result.forEach { container.viewContext.delete($0) }
            try container.viewContext.save()
        } catch {
            throw CoreDataError.deleteError(error)
        }
    }
}
