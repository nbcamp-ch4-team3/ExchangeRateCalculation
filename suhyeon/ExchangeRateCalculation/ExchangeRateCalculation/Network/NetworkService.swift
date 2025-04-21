//
//  NetworkService.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/14/25.
//

import Foundation

class NetworkService {
    func fetchExchangeRate() async throws -> ExchangeRateDTO {
        let urlString = "https://open.er-api.com/v6/latest/USD"

        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL(url: urlString)
        }
        let urlRequest = URLRequest(url: url)

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            // reponse 확인
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            // 상태 코드 확인
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }

            do {
                // 디코딩
                return try JSONDecoder().decode(ExchangeRateDTO.self, from: data)
            } catch {
                // 디코딩 실패
                throw NetworkError.decodingError(error: error)
            }
        } catch {
            if let networkError = error as? NetworkError {
                throw networkError
            }

            throw NetworkError.networkFailure(error: error)
        }
    }
}
