//
//  CoreDataError.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/22/25.
//

import Foundation

enum CoreDataError: Error {
    case fetchFailed
    case saveFailed
    case updateFailed
    case removeFailed
    
    var description: String {
        switch self {
        case .fetchFailed:
            return "Fetch failed."
        case .saveFailed:
            return "Save failed."
        case .updateFailed:
            return "Update failed."
        case .removeFailed:
            return "Remove failed."
        }
    }
}
