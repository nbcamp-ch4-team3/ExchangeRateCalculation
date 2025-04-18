//
//  RepositoryError.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/18/25.
//

import Foundation

enum RepositoryError: AppErrorProtocol {
    case itemNotFound(String)

    var errorDescription: String? {
        switch self {
        case .itemNotFound(let currency):
            "\(currency) 통화를 찾을 수 없습니다"
        }
    }

    var debugDescription: String {
        switch self {
        case .itemNotFound(let currency):
            "RepositoryError - itemNotFound: \(currency)"
        }
    }
}
