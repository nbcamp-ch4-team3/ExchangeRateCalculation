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
    func saveData(_ code: String, _ exchangeRate: Double, _ isBookmark: Bool) throws
    func updateExchangeRate(_ code: String, _ exchangeRate: Double) throws
    func updateIsBookmarked(_ code: String, _ isBookmarked: Bool) throws
    func removeData(_ code: String) throws
}

final class CurrencyCodeStorageService: CurrencyCodeStorageProtocol {
    private let coreDataStorage = CoreDataStorage.shared
    
    func fetchAllData() throws -> [CoreDataCurrency] {
        do {
            var currencyCodes: [CoreDataCurrency] = []
            
            let codes = try self.coreDataStorage.persistentContainer.viewContext.fetch(
                CurrencyCode.fetchRequest()
            )
            
            for code in codes as [NSManagedObject] {
                if let cureencyCode = code.value(forKey: CurrencyCode.Key.code) as? String,
                   let exchangeRate = code.value(forKey: CurrencyCode.Key.exchangeRate) as? Double,
                   let isBookmark = code.value(forKey: CurrencyCode.Key.isBookmark) as? Bool {
                   
                    let coreDataCurrency = CoreDataCurrency(
                        code: cureencyCode,
                        exchangeRate: exchangeRate,
                        isBookmark: isBookmark
                    )
                    
                    currencyCodes.append(coreDataCurrency)
                }
            }
            
            return currencyCodes
        } catch {
            throw CoreDataError.fetchFailed
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
