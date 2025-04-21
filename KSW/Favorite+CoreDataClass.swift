//
//  Favorite+CoreDataClass.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/18/25.
//
//

import Foundation
import CoreData

@objc(Favorite)
public class Favorite: NSManagedObject {
    static let entityName = "Favorite"
    struct Keys {
        static let currencyCode = "currencyCode"
    }
}
