//
//  UpdateDateStorageService.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/22/25.
//

import Foundation

protocol UpdateDateStorageProtocol {
    func saveDate(_ date: Date)
    func loadDate() -> Date?
    func updateDate(_ date: Date)
}

final class UpdateDateStorageService: UpdateDateStorageProtocol {
    private let userDefaults = UserDefaults.standard
    private let key = "updateDate"
    
    func saveDate(_ date: Date)  {
        userDefaults.set(date, forKey: key)
    }
    
    func loadDate() -> Date? {
        return userDefaults.value(forKey: key) as? Date
    }
    
    func updateDate(_ date: Date)  {
        userDefaults.set(date, forKey: key)
    }    
}
