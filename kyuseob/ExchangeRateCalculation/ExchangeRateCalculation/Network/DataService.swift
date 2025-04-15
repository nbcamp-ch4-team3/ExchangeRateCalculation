import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case apiError(String)

    var errorMessage: String {
        switch self {
        case .invalidURL:
            return "올바르지 않은 URL입니다."
        case .networkError(let error):
            return "\(error.localizedDescription)"
        case .invalidResponse:
            return "올바르지 않은 응답입니다."
        case .apiError(let message):
            return message
        }
    }
}

class DataService {
    func fetchExchangeRateData() async throws -> ExchangeRateResponse {
        let urlString = "https://open.er-api.com/v6/latest/USD"

        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw APIError.invalidResponse
            }

            let decoder = JSONDecoder()
            let exchangeRateData = try decoder.decode(ExchangeRateResponse.self, from: data)

            guard exchangeRateData.result == "success" else {
                throw APIError.apiError("API 호출에 실패했습니다.")
            }

            return exchangeRateData
        } catch let error as APIError {
            throw APIError.networkError(error)
        } catch {
            throw error
        }
    }
}
