//
//  AppError.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/18/25.
//

import Foundation

protocol AppErrorProtocol: LocalizedError {
    var errorDescription: String? { get }
    var debugDescription: String { get }
}

enum AppError: AppErrorProtocol {
    case network(NetworkError)
    case coreData(CoreDataError)
    case calculator(CalculatorError)
    case unKnown(Error)

    init(_ error: Error) {
        switch error {
        case let error as NetworkError:
            self = .network(error)
        case let error as CoreDataError:
            self = .coreData(error)
        case let error as CalculatorError:
            self = .calculator(error)
        default:
            self = .unKnown(error)
        }
    }
}

extension AppError {
    var errorDescription: String? {
        switch self {
        case .network(let networkError):
            networkError.errorDescription
        case .coreData(let coreDataError):
            coreDataError.errorDescription
        case .calculator(let calculatorError):
            calculatorError.errorDescription
        case .unKnown:
            "알 수 없는 오류가 발생했습니다"
        }
    }

    var debugDescription: String {
        switch self {
        case .network(let networkError):
            networkError.debugDescription
        case .coreData(let coreDataError):
            coreDataError.debugDescription
        case .calculator(let calculatorError):
            calculatorError.debugDescription
        case .unKnown(let error):
            "알 수 없는 에러 발생: \(error.localizedDescription)"
        }
    }
}

extension AppError {
    enum AlertType: String {
        case networkError = "네트워크 오류"
        case defaultError = "오류"
    }

    var alertType: AlertType {
        switch self {
        case .network:
            return .networkError
        default:
            return .defaultError
        }
    }
}
