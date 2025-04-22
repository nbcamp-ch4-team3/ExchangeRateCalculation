//
//  CurrencyCode+CoreDataProperties.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/21/25.
//
//

import Foundation
import CoreData


extension CurrencyCode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyCode> {
        return NSFetchRequest<CurrencyCode>(entityName: "CurrencyCode")
    }

    @NSManaged public var code: String?
    @NSManaged public var exchangeRate: Double
    @NSManaged public var isBookmark: Bool
}

extension CurrencyCode : Identifiable {

}
