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

class MainViewModel: ViewModelProtocol {
    private let networkService = NetworkService()
    private var cachedExchangeRates: ExchangeRates = [] // 전체 데이터 (캐시)

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
        self.action = { action in
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
                // 매핑 + 정렬
                let exchangeRates = makeExchageRates(from: result.rates)
                cachedExchangeRates = exchangeRates

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
        if keyword.isEmpty {
            state.exchangeRates = cachedExchangeRates
        } else {
            let uppercasedKeyword = keyword.uppercased()
            state.exchangeRates = cachedExchangeRates.filter {
                $0.country.contains(uppercasedKeyword) || $0.currency.contains(uppercasedKeyword)
            }
        }

        state.updateExchangeRates?()
    }

    private func makeExchageRates(from rates: [String: Double]) -> ExchangeRates {
        return ExchangeRateMapper.makeExchangeRates(from: rates)
    }
}
