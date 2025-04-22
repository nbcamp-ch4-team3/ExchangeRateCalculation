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
        return NSFetchRequest<Currency>(entityName: Currency.entityName)
    }
    
    @NSManaged public var code: String // 통화 코드(예: USD)
    @NSManaged public var country: String // 통화 국가(예: 미국)
    @NSManaged public var rate: Double // 환율(예: 1.000)
    @NSManaged public var isFavorite: Bool
    @NSManaged public var timestamp: TimeInterval // 업데이트 일시
    @NSManaged public var previousRate: Double // 이전 환율 정보(매일 업데이트 시 어제 기준)
}

extension Currency {
    var rateIcon: String {
        let difference = abs(rate - previousRate)
        
        if difference > 0.01, rate > previousRate {
            return "🔼"
        } else if difference > 0.01, rate < previousRate {
            return "🔽"
        } else {
            return "  "
        }
    }
}

extension Currency : Identifiable {}
