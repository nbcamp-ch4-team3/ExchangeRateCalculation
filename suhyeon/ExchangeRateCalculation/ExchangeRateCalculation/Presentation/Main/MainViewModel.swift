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
    private let lastScreenUseCase: LastScreenUseCaseProtocol
    private let exchangeRateUseCase: ExchangeRateUseCaseProtocol

    var action: ((Action) -> Void)?
    var state = State()

    enum Action {
        case restoreLastVisitedScreen
        case saveLastScreen(screen: Screen, exchangeRate: ExchangeRate?)
        case loadExchangeRates
        case filterExchangeRates(String)
        case toggleFavoriteItem(currency: String)
    }

    struct State {
        fileprivate(set) var exchangeRates: ExchangeRates = []

        var navigateToCalculator: ((ExchangeRate) -> Void)?
        var updateExchangeRates: (() -> Void)?
        var handleError: ((AppError) -> Void)?
    }

    init(lastScreenUseCase: LastScreenUseCaseProtocol, exchangeRateUseCase: ExchangeRateUseCaseProtocol) {
        self.lastScreenUseCase = lastScreenUseCase
        self.exchangeRateUseCase = exchangeRateUseCase

        self.action = {[weak self] action in
            guard let self else { return }

            switch action {
            case .restoreLastVisitedScreen:
                self.restoreLastVisitedScreen()
            case .saveLastScreen(let screen, let exchangeRate):
                self.saveLastScreen(screen: screen, exchangeRate: exchangeRate)
            case .loadExchangeRates:
                self.loadExchangeRates()
            case .filterExchangeRates(let keyword):
                self.filterExchangeRates(with: keyword)
            case .toggleFavoriteItem(let currency):
                self.toggleFavoriteItem(with: currency)
            }
        }
    }

    private func restoreLastVisitedScreen() {
        do {
            let lastScreen = try lastScreenUseCase.readLastScreen()
            guard let lastScreen,
                  let cdExchangeRate = lastScreen.cdExchangeRate else { return }
            switch lastScreen.screenName {
            case Screen.calculator.rawValue:
                let exchangeRate = ExchangeRate(
                    currency: cdExchangeRate.currency,
                    rate: cdExchangeRate.rate,
                    fluctuation: Fluctuation(fluctuation: cdExchangeRate.fluctuation)
                )
                state.navigateToCalculator?(exchangeRate)
            default:
                return
            }
        } catch {
            state.handleError?(AppError(error))
        }
    }

    private func saveLastScreen(screen: Screen, exchangeRate: ExchangeRate?) {
        do {
            try lastScreenUseCase.saveLastScreen(screen: screen, exchangeRate: exchangeRate)
        } catch {
            state.handleError?(AppError(error))
        }
    }

    // 환율 데이터 불러오는 메서드
    private func loadExchangeRates() {
        Task {
            do {
                let result = try await exchangeRateUseCase.fetchExchangeRates()
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

    // 검색 필터링 메서드
    private func filterExchangeRates(with keyword: String) {
        // 검색어를 모두 지웠을 때는 다시 전체 데이터로 변환
        state.exchangeRates = keyword.isEmpty
            ? exchangeRateUseCase.loadExchangeRates()
            : exchangeRateUseCase.filterExchangeRates(with: keyword)

        state.updateExchangeRates?()
    }

    // 즐겨찾기 추가 / 삭제 메서드
    private func toggleFavoriteItem(with currency: String) {
        do {
            let result = try exchangeRateUseCase.toggleFavoriteItem(with: currency)
            state.exchangeRates = result
            state.updateExchangeRates?()
        }
        catch {
            state.handleError?(AppError(error))
        }
    }
}
