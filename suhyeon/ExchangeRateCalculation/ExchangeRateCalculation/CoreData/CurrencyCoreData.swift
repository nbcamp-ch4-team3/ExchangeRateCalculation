//
//  CurrencyCoreData.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/17/25.
//

import UIKit
import CoreData

enum CoreDataError: LocalizedError {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)

    var errorDescription: String? {
        "관리자에게 문의 부탁드립니다"
    }

    var debugDescription: String {
        switch self {
        case .readError(let error):
            "CoreDataError - readError: \(error.localizedDescription)"
        case .saveError(let error):
            "CoreDataError - saveError: \(error.localizedDescription)"
        case .deleteError(let error):
            "CoreDataError - deleteError: \(error.localizedDescription)"
        }
    }
}

final class CurrencyCoreData {
    private var container: NSPersistentContainer

    init(container: NSPersistentContainer) {
        self.container = container
    }

    func readAllData() -> Result<[String], CoreDataError> {
        let viewContext = container.viewContext

        do {
            let result = try viewContext.fetch(Currency.fetchRequest())
            return .success(result.compactMap { $0.currency })
        } catch {
            return .failure(.readError(error))
        }
    }

    func saveData(currency: String) -> Result<Void, CoreDataError> {
        let viewContext = container.viewContext
        let currencyObject = Currency(context: viewContext) // Currency 객체 생성 및 viewContext에 등록
        currencyObject.currency = currency // 객체의 속성 할당

        do {
            try viewContext.save()
            return .success(())
        } catch {
            return .failure(.saveError(error))
        }
    }

    func deleteData(currency: String) -> Result<Void, CoreDataError> {
        let fetchRequest: NSFetchRequest<Currency> = Currency.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "currency == %@", currency)

        do {
            let result = try container.viewContext.fetch(fetchRequest)
            result.forEach { container.viewContext.delete($0) }
            return .success(())
        } catch {
            return .failure(.deleteError(error))
        }
    }

    func deleteAllData() -> Result<Void, CoreDataError> {
        let fetchRequest: NSFetchRequest<Currency> = Currency.fetchRequest()

        do {
            let result = try container.viewContext.fetch(fetchRequest)
            result.forEach { container.viewContext.delete($0) }
            return .success(())
        } catch {
            return .failure(.deleteError(error))
        }
    }
}
