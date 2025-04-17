//
//  ExchangeRateViewModel.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/17/25.
//

import Foundation

final class ExchangeRateViewModel: ViewModelProtocol {
    private let neworkService: NetworkService
    
    enum Action {
        case fetch
        case search(text: String)
    }
    
    struct State {
        var exchangeRates: [ExchangeRate] = []
        var searchRates: [ExchangeRate] = []
        var isSearching: Bool = false
        var errorMessage: String? = nil
    }
    
    var action: ((Action) -> Void)?
    private(set) var state: State {
        didSet {
            onStateChanged?(state)
        }
    }
    var onStateChanged: ((State) -> Void)?
    
    init(networkService: NetworkService) {
        self.neworkService = networkService
        self.state = State()
        
        self.action = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .fetch:
                self.fetchData()
            case let .search(text):
                self.search(text: text)
            }
        }
    }
    
    private func fetchData() {
        Task { [weak self] in
            guard let self else { return }
            
            do {
                let rates = try await neworkService.getExchangeRate(nation: "USD").toModel()
                
                await MainActor.run {
                    self.state.exchangeRates = rates
                }
            } catch let error as NetworkError {
                await MainActor.run {
                    self.state.errorMessage = error.description
                }
            } catch {
                await MainActor.run {
                    self.state.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func search(text: String) {
        guard !text.isEmpty else {
            state.searchRates = []
            state.isSearching = false
            return
        }
        
        state.isSearching = true
        if text.isHangul {
            state.searchRates = state.exchangeRates.filter { $0.nation.contains(text) }
        } else {
            state.searchRates = state.exchangeRates.filter {
                $0.currencyCode.contains(text.uppercased())
            }
        }
    }
}
