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
    private let networkService = NetworkService()

    var action: ((Action) -> Void)?
    var state = State()

    enum Action {
        case loadExchangeRates
        case filterExchangeRates(String)
    }

    struct State {
        fileprivate(set) var exchangeRates: ExchangeRates = []

        var updateExchangeRates: (() -> Void)?
        var handleNetworkError: ((NetworkError) -> Void)?
    }

    init() {
        self.action = {[weak self] action in
            guard let self else { return }

            switch action {
            case .loadExchangeRates:
                self.loadExchangeRates()
            case .filterExchangeRates(let keyword):
                self.filterExchangeRates(with: keyword)
            }
        }
    }

    private func loadExchangeRates() {
        Task {
            let result = await networkService.fetchExchangeRate()
            switch result {
            case .success(let result):
                ExchangeRateStorage.shared.saveExchangeRates(from: result.rates) // 싱글톤에 저장
                let exchangeRates = ExchangeRateStorage.shared.loadExchangeRates() // 불러오기

                await MainActor.run {
                    state.exchangeRates = exchangeRates
                    state.updateExchangeRates?()
                }
            case .failure(let error):
                await MainActor.run {
                    state.handleNetworkError?(error)
                }
            }
        }
    }

    private func filterExchangeRates(with keyword: String) {
        // 검색어를 모두 지웠을 때는 다시 전체 데이터로 변환
        state.exchangeRates = keyword.isEmpty
            ? ExchangeRateStorage.shared.loadExchangeRates()
            : ExchangeRateStorage.shared.filterExchangeRates(with: keyword)

        state.updateExchangeRates?()
    }
}
