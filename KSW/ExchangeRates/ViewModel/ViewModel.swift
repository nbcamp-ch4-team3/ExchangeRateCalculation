//
//  ViewModel.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/15/25.
//

import Foundation

protocol ViewModelDelegate: AnyObject {
    func viewModelDidLoadData(navigationDestination currency: Currency?)
    func viewModel(didFailWithError error: Error)
    func viewModelDidFilterData()
}

final class ViewModel {
    weak var delegate: ViewModelDelegate?
    
    private let networkService: NetworkServiceProtocol
    private let mockDataProvider: NetworkServiceProtocol
    private let dataManager = DataManager.shared
    
    private var currencies: [Currency] = []
    private(set) var filteredCurrencies: [Currency] = []
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        
        // 목 데이터 구성(4월 22일 기준 환율 제공)
        self.mockDataProvider = MockDataProvider()
        mockDataProvider.fetchData(from: URL(string: "https://open.er-api.com/v6/latest/USD")!) { [weak self] result in
            guard let self else { return }
            
            switch result {
                case .success(let response):
                fetchCurrencies()
                updateCurrencies(to: response)
                
            case .failure(let error):
                print("Mok API error: \(error)")
            }
        }
    }
    
    func loadCurrencies() {
        fetchCurrencies() // 환율 정보 core data 로드
        
        // 환율 정보 API 수신
        let url = URL(string: "https://open.er-api.com/v6/latest/USD")!
        networkService.fetchData(from: url) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                updateCurrencies(to: response) // 환율 정보 업데이트
                
                filteredCurrencies = currencies
                sortCurrencies()
                
                // 마지막 화면 정보가 있으면 뷰 컨트롤러로 해당 환율정보 송신
                let currencyCode = UserDefaults.standard.string(forKey: UserDefaultsKey.lastDetailView)
                let currency = currencies.filter { $0.code == currencyCode }.first
                
                delegate?.viewModelDidLoadData(navigationDestination: currency)
                
            case .failure(let error):
                delegate?.viewModel(didFailWithError: error)
            }
        }
        
        // 환율 정보 API 수신(Alamofire 적용)
//        networkService.fetchDataByAlamofire(from: url) { [weak self] result in
//            guard let self else { return }
//            
//            switch result {
//            case .success(let response):
//                updateCurrencies(to: response)
//                filteredCurrencies = currencies
//                sortCurrencies()
//                let currencyCode = UserDefaults.standard.string(forKey: UserDefaultsKey.lastDetailView)
//                let currency = currencies.filter { $0.code == currencyCode }.first
//                delegate?.viewModelDidLoadData(navigationDestination: currency)
//                
//            case .failure(let error):
//                delegate?.viewModel(didFailWithError: error)
//            }
//        }
    }
    
    private func fetchCurrencies() {
        do {
            currencies = try dataManager.context.fetch(Currency.fetchRequest())
        } catch {
            print("fetch error: \(error)")
        }
    }
    
    private func updateCurrencies(to response: CurrencyResponse) {
        let responseDate = Date(timeIntervalSince1970: TimeInterval(response.timestamp))
        
        for (key, value) in response.rates {
            if let index = currencies.firstIndex(where: { $0.code == key }) {
                
                // 기존 업데이트 일시 확인
                let currencyDate = Date(timeIntervalSince1970: TimeInterval(currencies[index].timestamp))
                
                // (업데이트가 필요하면) 기존 데이터 업데이트
                if currencyDate < responseDate {
                    currencies[index].previousRate = currencies[index].rate
                    currencies[index].rate = value
                    currencies[index].timestamp = response.timestamp
                }
                
            } else {
                // 기존 데이터 없으면 새로 생성
                let currency = Currency(context: dataManager.context)
                currency.code = key
                currency.country = countryCodes[key] ?? ""
                currency.rate = value
                currency.isFavorite = false
                currency.timestamp = response.timestamp
                currency.previousRate = 0.0
                currencies.append(currency)
            }
        }
        
        dataManager.saveContext()
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
}
