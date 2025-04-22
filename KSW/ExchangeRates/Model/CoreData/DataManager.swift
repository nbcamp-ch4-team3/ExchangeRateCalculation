//
//  DataManager.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/21/25.
//

import UIKit
import CoreData

final class DataManager {
    static let shared = DataManager()
    
    var container: NSPersistentContainer!
    var context: NSManagedObjectContext!
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        container = appDelegate.persistentContainer
        context = container.viewContext
    }
    
    func saveContext () {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
