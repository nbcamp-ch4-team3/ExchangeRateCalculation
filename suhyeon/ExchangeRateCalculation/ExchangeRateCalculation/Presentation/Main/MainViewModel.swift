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
        case fetchExchangeRate
        case searchExchangeRate(String)
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
            case .searchExchangeRate(let searchText):
                self.searchExchangeRate(with: searchText)
            }
        }
    }

    private func fetchExchangeRate() {
        Task {
            let result = await networkService.fetchExchangeRate()
            switch result {
            case .success(let result):
                // 매핑 + 정렬
                let exchangeRates = countryMapping(with: result.rates)
                cachedExchangeRates = exchangeRates

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

    private func searchExchangeRate(with text: String) {
        // 검색어를 모두 지웠을 때는 다시 전체 데이터로 변환
        if text.isEmpty {
            state.exchangeRates = cachedExchangeRates
        } else {
            let uppercasedText = text.uppercased()
            state.exchangeRates = cachedExchangeRates.filter {
                $0.country.contains(uppercasedText) || $0.currency.contains(uppercasedText)
            }
        }

        state.successFetchData?()
    }

    private func countryMapping(with rates: [String: Double]) -> ExchangeRates {
        return rates
            .sorted { $0.key < $1.key }
            .compactMap { (currency, rate) in
                guard let country = CountryMapping[currency] else { return nil }
                return ExchangeRate(country: country, currency: currency, rate: rate)
            }
    }
}
