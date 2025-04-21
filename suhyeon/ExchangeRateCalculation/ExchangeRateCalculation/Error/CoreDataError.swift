//
//  CoreDataError.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/18/25.
//

import Foundation

enum CoreDataError: AppErrorProtocol {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
}

extension CoreDataError {
    var errorDescription: String? {
        "관리자에게 문의 부탁드립니다"
    }

    var debugDescription: String {
        switch self {
        case .readError(let error):
            "CoreDataError - readError: \(error.localizedDescription)"
        case .saveError(let error):
            "CoreDataError - saveError: \(error.localizedDescription)"
        case .deleteError(let error):
            "CoreDataError - deleteError: \(error.localizedDescription)"
        }
    }
}
