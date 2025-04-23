//
//  LastSceneDataStorageService.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/23/25.
//

import CoreData
import Foundation

protocol LastSceneDataStorageProtocol {
    func fetchLastScene() -> LastSceneInfo?
    func saveLastScene(_ scene: String, _ searchText: String?, _ code: String?)
    func removeLastScene()
}

final class LastSceneDataStorageService: LastSceneDataStorageProtocol {
    private let coreDataStorage = CoreDataStorage.shared
    
    
    func fetchLastScene() -> LastSceneInfo? {
        let context = coreDataStorage.persistentContainer.viewContext
        let fetchRequest = LastSceneData.fetchRequest()
        
        do {
            if let entity = try context.fetch(fetchRequest).first {
                return LastSceneInfo(
                    code: entity.code ?? "",
                    scene: entity.scene ?? "",
                    searchText: entity.searchText ?? ""
                )
            }
        } catch {
            print("fetchLastScene failed: \(error)")
        }
        return nil
    }
    
    func saveLastScene(_ scene: String, _ searchText: String?, _ code: String?) {
        let context = coreDataStorage.persistentContainer.viewContext
        
        removeLastScene()
        
        let entity = LastSceneData(context: context)
        entity.scene = scene
        entity.searchText = searchText
        entity.code = code
        
        do {
            try context.save()
        } catch {
            print("saveLastScene failed: \(error)")
        }
    }
    
    func removeLastScene() {
        let context = coreDataStorage.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = LastSceneData.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("removeLastScene failed: \(error)")
        }
    }
}

