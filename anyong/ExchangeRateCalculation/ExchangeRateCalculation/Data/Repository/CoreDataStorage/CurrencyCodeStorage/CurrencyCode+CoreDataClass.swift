//
//  CurrencyCode+CoreDataClass.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/18/25.
//
//

import Foundation
import CoreData

@objc(ExchangeRate)
public class CurrencyCode: NSManagedObject {
    public static let entityName: String = "CurrencyCode"
    public enum Key {
        static let code = "code"
    }
}
