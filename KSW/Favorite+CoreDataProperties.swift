//
//  Favorite+CoreDataProperties.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/18/25.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: Favorite.entityName)
    }

    @NSManaged public var currencyCode: String?

}

extension Favorite : Identifiable {

}
