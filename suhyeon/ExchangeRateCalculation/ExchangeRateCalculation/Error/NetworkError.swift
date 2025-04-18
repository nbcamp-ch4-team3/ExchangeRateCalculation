//
//  NetworkError.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/14/25.
//

import Foundation

enum NetworkError: AppErrorProtocol {
    case invalidURL(url: String)
    case invalidResponse
    case decodingError(error: Error)
    case serverError(statusCode: Int)
    case networkFailure(error: Error)
}

// 사용자 메시지 정의
extension NetworkError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "요청에 문제가 발생했어요.\n 다시 시도해주세요."
        case .invalidResponse:
            return "서버로부터 올바른 응답을 받지 못했어요.\n 잠시 후 다시 시도해주세요."
        case .decodingError:
            return "데이터 처리 중 오류가 발생했어요.\n 다시 시도해주세요."
        case .serverError(let statusCode):
            return "서버 오류가 발생했어요.\n (오류 코드: \(statusCode))"
        case .networkFailure:
            return "네트워크 연결에 실패했어요.\n 인터넷 상태를 확인해주세요."
        }
    }
}

// 디버깅용 메시지 정의
extension NetworkError {
    var debugDescription: String {
        switch self {
        case .invalidURL(let url):
            "invalidURL: \(url)"
        case .invalidResponse:
            "invalidResponse"
        case .decodingError(let message):
            "decodingError: \(message)"
        case .serverError(let statusCode):
            "serverError - StatusCode: \(statusCode)"
        case .networkFailure(let message):
            "networkFailure: \(message)"
        }
    }
}
