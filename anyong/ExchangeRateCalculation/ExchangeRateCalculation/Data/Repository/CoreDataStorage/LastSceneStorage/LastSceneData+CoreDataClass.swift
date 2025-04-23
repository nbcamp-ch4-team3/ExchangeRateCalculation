//
//  LastSceneData+CoreDataClass.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/23/25.
//
//

import Foundation
import CoreData

@objc(LastSceneData)
public class LastSceneData: NSManagedObject {
    public static let entityName: String = "LastSceneData"
    public enum Key {
        static let code: String = "code"
        static let scene: String = "scene"
        static let searchText: String = "searchText"
    }
}
