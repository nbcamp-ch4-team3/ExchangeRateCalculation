//
//  MainViewModel.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/15/25.
//

import Foundation

protocol ViewModelProtocol {
    associatedtype Action
    associatedtype State

    var state: State { get }
    var action: ((Action) -> Void)? { get }
}

final class MainViewModel: ViewModelProtocol {

    var action: ((Action) -> Void)?
    var state = State()

    enum Action {
        case loadExchangeRates
        case filterExchangeRates(String)
        case toggleFavoriteItem(currency: String)
    }

    struct State {
        fileprivate(set) var exchangeRates: ExchangeRates = []

        var updateExchangeRates: (() -> Void)?
        var handleError: ((AppError) -> Void)?
    }

    init() {
        self.action = {[weak self] action in
            guard let self else { return }

            switch action {
            case .loadExchangeRates:
                self.loadExchangeRates()
            case .filterExchangeRates(let keyword):
                self.filterExchangeRates(with: keyword)
            case .toggleFavoriteItem(let currency):
                self.toggleFavoriteItem(with: currency)
            }
        }
    }

    private func loadExchangeRates() {
        Task {
            do {
                let result = try await ExchangeRateRepository.shared.fetchExchangeRate()
                await MainActor.run {
                    state.exchangeRates = result
                    state.updateExchangeRates?()
                }
            } catch {
                await MainActor.run {
                    state.handleError?(AppError(error))
                }
            }
        }
    }

    private func filterExchangeRates(with keyword: String) {
        // 검색어를 모두 지웠을 때는 다시 전체 데이터로 변환
        state.exchangeRates = keyword.isEmpty
            ? ExchangeRateRepository.shared.loadExchangeRates()
            : ExchangeRateRepository.shared.filterExchangeRates(with: keyword)

        state.updateExchangeRates?()
    }

    private func toggleFavoriteItem(with currency: String) {
        do {
            let result = try ExchangeRateRepository.shared.toggleFavoriteItem(with: currency)
            state.exchangeRates = result
            state.updateExchangeRates?()
        }
        catch {
            state.handleError?(AppError(error))
        }
    }
}
