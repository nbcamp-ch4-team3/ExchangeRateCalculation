//
//  NetworkError.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/15/25.
//

import Foundation

enum NetworkError: Error {
    case networkFail
    case decodeError
    case etc
    
    var description: String {
        switch self {
        case .networkFail:
            return "네트워크 통신 과정에서 오류가 발생했습니다."
        case .decodeError:
            return "디코딩 과정에서 오류가 발생했습니다."
        case .etc:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
