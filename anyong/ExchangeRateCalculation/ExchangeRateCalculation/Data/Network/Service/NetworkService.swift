//
//  NetworkService.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/15/25.
//

import Foundation

import Moya

protocol NetworkServiceProtocol {
    func getExchangeRate(nation: String) async throws -> ExchangeRateDTO
}

final class NetworkService: NetworkServiceProtocol {
    let provider = MoyaProvider<NetworkTargetType>()
    
    func getExchangeRate(nation: String) async throws -> ExchangeRateDTO {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.getExchangeRate(nation: nation)) { result in
                switch result {
                case .success(let response):
                    guard (200...299).contains(response.statusCode) else {
                        continuation.resume(throwing: NetworkError.networkFail)
                        return
                    }
                    
                    do {
                        let responseData = try response.map(ExchangeRateDTO.self)
                        
                        continuation.resume(returning: responseData)
                    } catch {
                        continuation.resume(throwing: NetworkError.decodeError)
                    }
                case .failure:
                    continuation.resume(throwing: NetworkError.etc)
                }
            }
        }
    }
}
