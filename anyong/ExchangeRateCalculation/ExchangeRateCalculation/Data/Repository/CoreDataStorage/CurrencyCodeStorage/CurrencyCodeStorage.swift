//
//  CurrencyCodeStorage.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/18/25.
//

import CoreData
import Foundation

protocol CurrencyCodeStorageProtocol {
    func getCodeAll() -> [String]
    func saveCode(_ code: String)
    func removeCode(_ code: String)
}

final class CurrencyCodeStorage: CurrencyCodeStorageProtocol {
    private let coreDataStorage = CoreDataStorage.shared
    
    func getCodeAll() -> [String] {
        do {
            var currencyCodes: [String] = []
            
            let codes = try self.coreDataStorage.persistentContainer.viewContext.fetch(
                CurrencyCode.fetchRequest()
            )
            
            for code in codes as [NSManagedObject] {
                if let code = code.value(forKey: CurrencyCode.Key.code) as? String {
                    currencyCodes.append(code)
                }
            }
            
            return currencyCodes
        } catch {
            print("데이터 읽기 실패")
            return []
        }
    }
    
    func saveCode(_ code: String) {
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
        
        do {
            try coreDataStorage.persistentContainer.viewContext.save()
            print("저장 성공")
        } catch {
            print("저장 실패")
        }
    }
    
    func removeCode(_ code: String) {
        let fetchRequest = CurrencyCode.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(CurrencyCode.Key.code) == %@", code)
        
        do {
            let result = try coreDataStorage.persistentContainer.viewContext.fetch(fetchRequest)
            
            for data in result as [NSManagedObject] {
                coreDataStorage.persistentContainer.viewContext.delete(data)
                print("삭제된 데이터: \(data)")
            }
            
            try coreDataStorage.persistentContainer.viewContext.save()
            print("삭제 완료")
        } catch {
            print("삭제 실패")
        }
    }
}
