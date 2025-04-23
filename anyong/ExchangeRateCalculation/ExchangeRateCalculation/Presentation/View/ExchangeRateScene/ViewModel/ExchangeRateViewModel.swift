//
//  ExchangeRateViewModel.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/17/25.
//

import Foundation

final class ExchangeRateViewModel: ViewModelProtocol {
    private let neworkService: NetworkService
    private let currencyCodeStorage: CurrencyCodeStorageService
    private let updateDateStorage: UpdateDateStorageService
    
    enum Action {
        case fetch
        case search(text: String)
        case didTapStar(code: String, isSelected: Bool)
        case setState(text: String)
    }
    
    struct State {
        var exchangeRates: [ExchangeRate] = []
        var searchRates: [ExchangeRate] = []
        var isSearching: Bool = false
        var searchText: String = ""
        var errorMessage: String? = nil
    }
    
    var action: ((Action) -> Void)?
    private(set) var state: State {
        didSet {
            onStateChanged?(state)
        }
    }
    var onStateChanged: ((State) -> Void)?
    
    init(
        networkService: NetworkService,
        currencyCodeStorage: CurrencyCodeStorageService,
        updateDateStorage: UpdateDateStorageService
    ) {
        self.neworkService = networkService
        self.currencyCodeStorage = currencyCodeStorage
        self.updateDateStorage = updateDateStorage
        self.state = State()
        
        self.action = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .fetch:
                self.fetchData()
            case let .search(text):
                self.search(text: text)
            case let .didTapStar(code, isSelected):
                self.didTapStarButton(code: code, isSelected: isSelected)
            case let .setState(text):
                self.state.searchText = text
            }
        }
    }
    
    private func fetchData() {
        Task { [weak self] in
            guard let self else { return }
            
            do {
                let fetchedRates = try await self.neworkService.getExchangeRate(nation: "USD").toModel()
//                let fetchedRates = self.neworkService.getMockData().toModel()
                let savedCodes = try self.currencyCodeStorage.fetchAllData()
                 
                if savedCodes.isEmpty {
                    print("날짜 초기화")
                    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
                    updateDateStorage.saveDate(yesterday!)
                    try fetchedRates.forEach { currency in
                        try self.currencyCodeStorage.saveData(
                            currency.currencyCode,
                            currency.rate,
                            currency.isBookmark
                        )
                    }
                }
                
                if let date = updateDateStorage.loadDate(),
                   !date.isToday {
                    print("날짜 갱신")
                    updateDateStorage.updateDate(Date.now)
                    
                    try fetchedRates.forEach { rate in
                        try self.currencyCodeStorage.updateExchangeRate(rate.currencyCode, rate.rate)
                    }
                }

                let updatedRates = fetchedRates.map { rate in
                    var newRate = rate
                    if let index = savedCodes.firstIndex(where: { $0.code == rate.currencyCode }) {
                        newRate.isBookmark = savedCodes[index].isBookmark
                        newRate.fluctuationType = self.checkIsFluctuation(rate.rate, savedCodes[index].exchangeRate)
                    }
                    return newRate
                }.sorted { $0.isBookmark && !$1.isBookmark }
                
                await MainActor.run {
                    self.state.exchangeRates = updatedRates
                    self.search(text: self.state.searchText)
                }
            } catch let error as NetworkError {
                await MainActor.run {
                    self.state.errorMessage = error.description
                }
            } catch let error as CoreDataError {
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
            state.searchText = ""
            state.searchRates = []
            state.isSearching = false
            return
        }
        state.searchText = text
        state.isSearching = true
        if text.isHangul {
            state.searchRates = state.exchangeRates.filter { $0.nation.contains(text) }
        } else {
            state.searchRates = state.exchangeRates.filter {
                $0.currencyCode.contains(text.uppercased())
            }
        }
    }
    
    private func didTapStarButton(code: String, isSelected: Bool) {
        if let index = state.exchangeRates.firstIndex(where: { $0.currencyCode == code }) {
            state.exchangeRates[index].isBookmark = isSelected
            state.exchangeRates.sort { $0.currencyCode < $1.currencyCode }
            state.exchangeRates.sort { $0.isBookmark && !$1.isBookmark }
            
            guard let index = state.searchRates.firstIndex(where: { $0.currencyCode == code}) else {
                return
            }
            
            state.searchRates[index].isBookmark = isSelected
            state.searchRates.sort { $0.currencyCode < $1.currencyCode }
            state.searchRates.sort { $0.isBookmark && !$1.isBookmark }

        } else {
            return
        }
        
        do {
            if isSelected {
                try currencyCodeStorage.updateIsBookmarked(code, isSelected)
            } else {
                try currencyCodeStorage.updateIsBookmarked(code, isSelected)
            }
        } catch let error as CoreDataError {
            state.errorMessage = error.description
        } catch {
            state.errorMessage = error.localizedDescription
        }
    }
    
    private func checkIsFluctuation(_ newRate: Double, _ oldRate: Double) -> fluctuationType {
        if newRate - oldRate > 0 {
            return .up
        } else if newRate - oldRate < 0 {
            return .down
        } else {
            return .equal
        }
    }
}
