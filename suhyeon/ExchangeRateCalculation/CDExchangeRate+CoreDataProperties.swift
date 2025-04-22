//
//  CDExchangeRate+CoreDataProperties.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/21/25.
//
//

import Foundation
import CoreData


extension CDExchangeRate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDExchangeRate> {
        return NSFetchRequest<CDExchangeRate>(entityName: "CDExchangeRate")
    }

    @NSManaged public var currency: String
    @NSManaged public var nextUpdateDate: Date
    @NSManaged public var rate: Double
    @NSManaged public var isFavorite: Bool
    @NSManaged public var fluctuation: String

}

extension CDExchangeRate : Identifiable {

}
