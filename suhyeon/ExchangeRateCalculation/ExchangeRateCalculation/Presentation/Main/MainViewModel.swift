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

    var action: ((Action) -> Void)? { get }
    var state: State { get }
}

class MainViewModel: ViewModelProtocol {
    private let networkService = NetworkService()

    var action: ((Action) -> Void)?
    var state = State()


    enum Action {
        case fetchExchangeRate
    }

    struct State {
        fileprivate(set) var exchangeRates: ExchangeRates = []

        var showNetworkErrorAlert: ((NetworkError) -> Void)?
        var successFetchData: (() -> Void)?
    }

    init() {
        self.action = { action in
            switch action {
            case .fetchExchangeRate:
                self.fetchExchangeRate()
            }
        }
    }

    private func fetchExchangeRate() {
        Task {
            let result = await networkService.fetchExchangeRate()
            switch result {
            case .success(let result):
                // 매핑 + 정렬
                let exchangeRates = countrymapping(with: result.rates)

                await MainActor.run {
                    state.exchangeRates = exchangeRates
                    state.successFetchData?()
                }
            case .failure(let error):
                await MainActor.run {
                    state.showNetworkErrorAlert?(error)
                }
            }
        }
    }

    private func countrymapping(with rates: [String: Double]) -> ExchangeRates {
        return rates
            .sorted { $0.key < $1.key }
            .compactMap { (currency, rate) in
                guard let country = countryMapping[currency] else { return nil }
                return ExchangeRate(country: country, currency: currency, rate: rate)
            }
    }
}
