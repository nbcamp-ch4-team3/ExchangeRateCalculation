//
//  ViewModel.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/15/25.
//

import Foundation

protocol ViewModelDelegate: AnyObject {
    func viewModelDidLoadData()
    func viewModel(didFailWithError error: Error)
    func viewModelDidFilterData()
}

final class ViewModel {
    weak var delegate: ViewModelDelegate?
    
    private let networkService: NetworkServiceProtocol
    private let dataManager = DataManager.shared
    
    private var currencies: [Currency] = []
    private(set) var filteredCurrencies: [Currency] = []
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func loadCurrencies() {
        fetchCurrencies() // core data 로드
        
        let url = URL(string: "https://open.er-api.com/v6/latest/USD")!
        networkService.fetchData(from: url) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                let responseDate = Date(timeIntervalSince1970: TimeInterval(response.timestamp))
                
                for (key, value) in response.rates {
                    if let index = currencies.firstIndex(where: { $0.code == key }) {
                        
                        // core data에 저장되어 있던 업데이트 일시 확인
                        let currencyDate: Date? = currencies[index].timestamp == 0.0 ? nil : Date(timeIntervalSince1970: TimeInterval(currencies[index].timestamp))
                        
                        // 기존 데이터 자료 업데이트
                        if let currencyDate, currencyDate < responseDate {
                            currencies[index].previousRate = currencies[index].rate
                            currencies[index].rate = value
                            currencies[index].timestamp = response.timestamp
                        }
                    } else {
                        // core data 저장 데이터가 없으면 새로 생성
                        let currency = Currency(context: dataManager.context)
                        currency.code = key
                        currency.country = countryCodes[key] ?? ""
                        currency.rate = value
                        currency.isFavorite = false
                        currency.timestamp = 0.0
                        currency.previousRate = 0.0
                        currencies.append(currency)
                    }
                }
                
                dataManager.saveContext()
                
                filteredCurrencies = currencies
                sortCurrencies()
                
                delegate?.viewModelDidLoadData()
                
            case .failure(let error):
                delegate?.viewModel(didFailWithError: error)
            }
        }
    }
    
    func filterCurrencies(searchText: String) {
        // 검색어가 없으면 원본 데이터를 반환하고 리턴
        if searchText.isEmpty {
            filteredCurrencies = currencies
            sortCurrencies()
            
            delegate?.viewModelDidFilterData()
            return
        }
        
        // 대소문자 및 문장 맨 앞뒤 공백 무시
        let searchResults = currencies.filter {
            $0.code.localizedStandardContains(searchText.trimmingCharacters(in: .whitespaces)) ||
            $0.country.localizedStandardContains(searchText.trimmingCharacters(in: .whitespaces))
        }
        
        // 검색 결과 반환
        if searchResults.isEmpty {
            filteredCurrencies = []
        } else {
            filteredCurrencies = searchResults
        }
        sortCurrencies()
        
        delegate?.viewModelDidFilterData()
    }
    
    // 정렬 우선순위: 1. 즐겨찾기 여부 2. 환율코드 알파벳
    func sortCurrencies() {
        filteredCurrencies.sort {
            if $0.isFavorite != $1.isFavorite {
                $0.isFavorite && !$1.isFavorite
            } else {
                $0.code < $1.code
            }
        }
    }
    
    func toggleFavorite(_ currency: Currency) {
        currency.isFavorite.toggle()
        
        dataManager.saveContext()
        
        filteredCurrencies = currencies
        sortCurrencies()
    }
    
    private func fetchCurrencies() {
        do {
            currencies = try dataManager.context.fetch(Currency.fetchRequest())
        } catch {
            print("fetch error: \(error)")
        }
    }
}
