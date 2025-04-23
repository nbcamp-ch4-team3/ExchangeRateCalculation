//
//  CurrencyCodeStorage.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/18/25.
//

import CoreData
import Foundation

protocol CurrencyCodeStorageProtocol {
    func fetchAllData() throws -> [CoreDataCurrency]
    func fetchData(_ code: String) -> CoreDataCurrency?
    func saveData(_ code: String, _ exchangeRate: Double, _ isBookmark: Bool) throws
    func updateExchangeRate(_ code: String, _ exchangeRate: Double) throws
    func updateIsBookmarked(_ code: String, _ isBookmarked: Bool) throws
    func removeData(_ code: String) throws
}

final class CurrencyCodeStorageService: CurrencyCodeStorageProtocol {
    private let coreDataStorage = CoreDataStorage.shared
    
    func fetchAllData() throws -> [CoreDataCurrency] {
        do {
            let context = self.coreDataStorage.backgroundContext
            var result: [CoreDataCurrency] = []
            
            try context.performAndWait {
                let codes = try context.fetch(CurrencyCode.fetchRequest()) as? [CurrencyCode] ?? []
                
                result = codes.compactMap {
                    CoreDataCurrency(
                        code: $0.code ?? "",
                        exchangeRate: $0.exchangeRate,
                        isBookmark: $0.isBookmark
                    )
                }
            }
            
            return result
        } catch {
            throw CoreDataError.fetchFailed
        }
    }
    
    func fetchData(_ code: String) -> CoreDataCurrency? {
        let fetchRequest = CurrencyCode.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "code == %@", code)
        
        do {
            let result = try coreDataStorage.persistentContainer.viewContext.fetch(fetchRequest) as [CurrencyCode]
            
            if result.isEmpty {
                return nil
            }
            
            let currency = CoreDataCurrency(
                code: result[0].code ?? "",
                exchangeRate: result[0].exchangeRate,
                isBookmark: result[0].isBookmark
            )
            
            return currency
        } catch {
            return nil
        }
    }
    
    func saveData(_ code: String, _ exchangeRate: Double, _ isBookmark: Bool) throws {
        guard let entity = NSEntityDescription.entity(
            forEntityName: CurrencyCode.entityName,
            in: coreDataStorage.persistentContainer.viewContext
        ) else {
            return
        }
        
        let newCurrecyCode = NSManagedObject(
            entity: entity,
            insertInto: coreDataStorage.persistentContainer.viewContext
        )
        
        newCurrecyCode.setValue(code, forKey: CurrencyCode.Key.code)
        newCurrecyCode.setValue(exchangeRate, forKey: CurrencyCode.Key.exchangeRate)
        newCurrecyCode.setValue(isBookmark, forKey: CurrencyCode.Key.isBookmark)
        
        do {
            try coreDataStorage.persistentContainer.viewContext.save()
        } catch {
            throw CoreDataError.saveFailed
        }
    }
    
    func updateExchangeRate(_ code: String, _ exchangeRate: Double) throws {
        let fetchRequest = CurrencyCode.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(CurrencyCode.Key.code) == %@", code)
        
        do {
            let result = try coreDataStorage.persistentContainer.viewContext.fetch(fetchRequest)
            
            for data in result as [NSManagedObject] {
                data.setValue(exchangeRate, forKey: CurrencyCode.Key.exchangeRate)
                
                try self.coreDataStorage.persistentContainer.viewContext.save()
            }
            
        } catch {
            throw CoreDataError.updateFailed
        }
    }
    
    func updateIsBookmarked(_ code: String, _ isBookmarked: Bool) throws {
        let fetchRequest = CurrencyCode.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(CurrencyCode.Key.code) == %@", code)
        
        do {
            let result = try coreDataStorage.persistentContainer.viewContext.fetch(fetchRequest)
            
            for data in result as [NSManagedObject] {
                data.setValue(isBookmarked, forKey: CurrencyCode.Key.isBookmark)
                
                try self.coreDataStorage.persistentContainer.viewContext.save()
            }
            
        } catch {
            throw CoreDataError.updateFailed
        }
    }
    
    func removeData(_ code: String) throws {
        let fetchRequest = CurrencyCode.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(CurrencyCode.Key.code) == %@", code)
        
        do {
            let result = try coreDataStorage.persistentContainer.viewContext.fetch(fetchRequest)
            
            for data in result as [NSManagedObject] {
                coreDataStorage.persistentContainer.viewContext.delete(data)
            }
            
            try coreDataStorage.persistentContainer.viewContext.save()
        } catch {
            throw CoreDataError.removeFailed
        }
    }
}
