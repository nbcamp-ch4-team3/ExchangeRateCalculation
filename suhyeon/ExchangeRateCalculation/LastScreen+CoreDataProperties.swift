//
//  LastScreen+CoreDataProperties.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/22/25.
//
//

import Foundation
import CoreData


extension LastScreen {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LastScreen> {
        return NSFetchRequest<LastScreen>(entityName: "LastScreen")
    }

    @NSManaged public var screenName: String?
    @NSManaged public var cdExchangeRate: CDExchangeRate?

}

extension LastScreen : Identifiable {

}
