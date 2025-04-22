//
//  CurrencyCode+CoreDataClass.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/21/25.
//
//

import Foundation
import CoreData

@objc(CurrencyCode)
public class CurrencyCode: NSManagedObject {
    public static let entityName: String = "CurrencyCode"
    public enum Key {
        static let code = "code"
        static let exchangeRate = "exchangeRate"
        static let isBookmark = "isBookmark"
    }
}
