//
//  Currency+CoreDataProperties.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/21/25.
//
//

import Foundation
import CoreData


extension Currency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Currency> {
        return NSFetchRequest<Currency>(entityName: "Currency")
    }

    @NSManaged public var code: String // 통화 코드(예: USD)
    @NSManaged public var country: String // 통화 국가(예: 미국)
    @NSManaged public var rate: Double // 환율(예: 1.000)
    @NSManaged public var isFavorite: Bool

}

extension Currency : Identifiable {

}
