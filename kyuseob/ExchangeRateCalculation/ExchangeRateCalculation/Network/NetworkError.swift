import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(Int)
    case clientError(Int)
    case decodingError(Error)
    case apiError(String)
    case unknownError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "올바르지 않은 URL입니다."
        case .invalidResponse:
            return "올바르지 않은 응답입니다."
        case .serverError(let code):
            return "서버 오류가 발생했습니다 (코드: \(code))"
        case .clientError(let code):
            return "요청에 문제가 있습니다 (코드: \(code))"
        case .decodingError(let error):
            return "데이터 디코딩 중 오류가 발생했습니다: \(error.localizedDescription)"
        case .apiError(let message):
            return "API 오류: \(message)"
        case .unknownError(let message):
            return message
        }
    }
}
