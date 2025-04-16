//
//  NetworkService.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/14/25.
//

import Foundation

class NetworkService {
    func fetchExchangeRate() async -> Result<ExchangeRateDTO, NetworkError> {
        let urlString = "https://open.er-api.com/v6/latest/USD"

        guard let url = URL(string: urlString) else {
            return .failure(.invalidURL(url: urlString))
        }
        let urlRequest = URLRequest(url: url)

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            // reponse 확인
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }

            // 상태 코드 확인
            guard (200...299).contains(httpResponse.statusCode) else {
                return .failure(.serverError(statusCode: httpResponse.statusCode))
            }

            do {
                // 디코딩
                let result = try JSONDecoder().decode(ExchangeRateDTO.self, from: data)
                return .success(result)
            } catch {
                // 디코딩 실패
                return .failure(.decodingError(error: error))
            }
        } catch {
            return .failure(.networkFailure(error: error))
        }
    }
}
