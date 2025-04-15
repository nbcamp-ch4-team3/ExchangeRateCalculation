//
//  NetworkService.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/15/25.
//

import Foundation

import Moya

protocol NetworkServiceProtocol {
    func getExchangeRate(nation: String) async throws -> ExchangeRateResponse
}

final class NetworkService: NetworkServiceProtocol {
    let provider = MoyaProvider<NetworkTargetType>()
    
    func getExchangeRate(nation: String) async throws -> ExchangeRateResponse {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.getExchangeRate(nation: nation)) { result in
                switch result {
                case .success(let response):
                    do {
                        let responseData = try response.map(ExchangeRateResponse.self)
                        
                        continuation.resume(returning: responseData)
                    } catch {
                        continuation.resume(throwing: NetworkError.decodeError)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
