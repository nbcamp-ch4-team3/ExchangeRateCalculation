//
//  LastSceneData+CoreDataProperties.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/23/25.
//
//

import Foundation
import CoreData


extension LastSceneData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LastSceneData> {
        return NSFetchRequest<LastSceneData>(entityName: LastSceneData.entityName)
    }

    @NSManaged public var scene: String?
    @NSManaged public var code: String?
    @NSManaged public var searchText: String?

}

extension LastSceneData : Identifiable {

}
