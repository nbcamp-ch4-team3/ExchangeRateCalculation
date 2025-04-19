//
//  CurrencyCode+CoreDataProperties.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/18/25.
//
//

import Foundation
import CoreData


extension CurrencyCode {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyCode> {
        return NSFetchRequest<CurrencyCode>(entityName: CurrencyCode.entityName)
    }

    @NSManaged public var Code: String?
}

extension CurrencyCode : Identifiable {

}
