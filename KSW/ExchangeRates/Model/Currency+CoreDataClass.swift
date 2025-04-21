//
//  Currency+CoreDataClass.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/21/25.
//
//

import Foundation
import CoreData

@objc(Currency)
public class Currency: NSManagedObject {
    static let entityName = "Currency"
    struct Keys {
        static let code = "code"
        static let country = "country"
        static let rate = "rate"
        static let isFavorite = "isFavorite"
    }
}
