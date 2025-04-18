import Foundation

protocol DataServiceProtocol {
    func fetchExchangeRateData() async throws -> ExchangeRateResponse
}

class DataService: DataServiceProtocol {
    func fetchExchangeRateData() async throws -> ExchangeRateResponse {
        let urlString = "https://open.er-api.com/v6/latest/USD"

        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            if (400...499).contains(httpResponse.statusCode) {
                throw NetworkError.clientError(httpResponse.statusCode)
            } else if (500...599).contains(httpResponse.statusCode) {
                throw NetworkError.serverError(httpResponse.statusCode)
            }

            do {
                let decoder = JSONDecoder()
                let exchangeRateData = try decoder.decode(ExchangeRateResponse.self, from: data)

                guard exchangeRateData.result == "success" else {
                    throw NetworkError.apiError("API 호출에 실패했습니다.")
                }

                return exchangeRateData
            } catch {
                throw NetworkError.decodingError(error)
            }
        } catch {
            throw NetworkError.unknownError("알 수 없는 오류가 발생했습니다.")
        }
    }
}
