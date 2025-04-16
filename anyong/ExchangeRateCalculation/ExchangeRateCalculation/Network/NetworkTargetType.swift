//
//  NetworkTargetType.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/15/25.
//

import Foundation

import Moya

enum NetworkTargetType {
    case getExchangeRate(nation: String)
}

extension NetworkTargetType: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://open.er-api.com/v6/latest/") else {
            fatalError("BaseURL must be valid URL")
        }
        
        return url
    }
    var path: String {
        switch self {
        case .getExchangeRate(let nation):
            return nation
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getExchangeRate:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getExchangeRate:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return .none
    }
}
