//
//  Currency+CoreDataProperties.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/17/25.
//
//

import Foundation
import CoreData


extension Currency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Currency> {
        return NSFetchRequest<Currency>(entityName: "Currency")
    }

    @NSManaged public var currency: String?

}

extension Currency : Identifiable {

}
