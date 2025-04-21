//
//  ExchangeRateCoreData.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/17/25.
//

import UIKit
import CoreData

final class ExchangeRateCoreData {
    private let container: NSPersistentContainer
    private let viewContext: NSManagedObjectContext

    init(container: NSPersistentContainer) {
        self.container = container
        self.viewContext = container.viewContext
    }

    // nextUpdateDate 불러오기
    func readNextUpdateDate() throws -> Date? {
        do {
            let result = try viewContext.fetch(CDExchangeRate.fetchRequest())
            return result.first?.nextUpdateDate
        }
    }

    func readAllData() throws -> [CDExchangeRate] {
        do {
            return  try viewContext.fetch(CDExchangeRate.fetchRequest())
        } catch {
            throw CoreDataError.readError(error)
        }
    }

    func saveData(data: ExchangeRate, nextUpdateDate: Date) throws {
        let exchangeRateObject = CDExchangeRate(context: viewContext) // CDExchangeRate 객체 생성 및 viewContext에 등록
        // 객체의 속성 할당
        exchangeRateObject.currency = data.currency
        exchangeRateObject.rate = data.rate
        exchangeRateObject.isFavorite = data.isFavorite
        exchangeRateObject.fluctuation = data.fluctuation.rawValue
        exchangeRateObject.nextUpdateDate = nextUpdateDate

        do {
            try viewContext.save()
        } catch {
            throw CoreDataError.saveError(error)
        }
    }

    //TODO: (updateDate, rate), isFavorite 업데이트 메서드 구현하기
    func updateIsFavorite(currency: String) throws {
        let fetchRequest: NSFetchRequest<CDExchangeRate> = CDExchangeRate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "currency == %@", currency)

        do {
            let result = try viewContext.fetch(fetchRequest)

            result.forEach { $0.isFavorite = !$0.isFavorite }
            try viewContext.save()
        } catch {
            throw CoreDataError.deleteError(error)
        }
    }

    func updateData(data: ExchangeRate, nextUpdateDate: Date) throws {
        let fetchRequest: NSFetchRequest<CDExchangeRate> = CDExchangeRate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "currency == %@", data.currency)

        do {
            let result = try viewContext.fetch(fetchRequest)
            result.forEach {
                $0.rate = data.rate
                $0.nextUpdateDate = nextUpdateDate
            }
            try viewContext.save()
        } catch {
            throw CoreDataError.deleteError(error)
        }
    }
}

extension ExchangeRateCoreData {
    func saveMockData() {
        let mockItems = ExchangeRate.mockExchangeRates
        let nextUpdateDate = Date().addingTimeInterval(50)

        for mockItem in mockItems {
            let exchangeRateObject = CDExchangeRate(context: viewContext) // CDExchangeRate 객체 생성 및
            // 객체의 속성 할당
            exchangeRateObject.currency = mockItem.currency
            exchangeRateObject.rate = mockItem.rate
            exchangeRateObject.isFavorite = mockItem.isFavorite
            exchangeRateObject.fluctuation = mockItem.fluctuation.rawValue
            exchangeRateObject.nextUpdateDate = nextUpdateDate
        }

        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    func deleteData(currency: String) throws {
        let fetchRequest: NSFetchRequest<CDExchangeRate> = CDExchangeRate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "currency == %@", currency)

        do {
            let result = try viewContext.fetch(fetchRequest)
            result.forEach { viewContext.delete($0) }
            try viewContext.save()
        } catch {
            throw CoreDataError.deleteError(error)
        }
    }

    func deleteAllData() throws {
        let fetchRequest: NSFetchRequest<CDExchangeRate> = CDExchangeRate.fetchRequest()

        do {
            let result = try viewContext.fetch(fetchRequest)
            result.forEach { viewContext.delete($0) }
            try viewContext.save()
        } catch {
            throw CoreDataError.deleteError(error)
        }
    }
}
