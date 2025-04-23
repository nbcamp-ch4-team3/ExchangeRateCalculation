//
//  LastScreenUseCase.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/23/25.
//

import Foundation

protocol LastScreenUseCaseProtocol {
    func readLastScreen() throws -> LastScreen?
    func saveLastScreen(screen: Screen, currency: String?) throws
}

final class LastScreenUseCase: LastScreenUseCaseProtocol {
    private let repository: LastScreenRepositoryProtocol

    init(repository: LastScreenRepositoryProtocol) {
        self.repository = repository
    }

    func readLastScreen() throws -> LastScreen? {
        try repository.readLastScreen()
    }

    func saveLastScreen(screen: Screen, currency: String?) throws {
        try repository.saveLastScreen(screen: screen, currency: currency)
    }
}
