//
//  DataManager.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/15/25.
//

import Foundation

protocol DataManagerDelegate: AnyObject {
    func dataManagerDidLoadData()
    func dataManager(didFailWithError error: Error)
    func dataManagerDidFilterData()
}

final class DataManager {
    weak var delegate: DataManagerDelegate?
    
    private let dataService: DataServiceProtocol
    private var exchangeRates: [ExchangeRate] = []
    private(set) var filteredExchangeRates: [ExchangeRate] = []
    
    init(dataService: DataServiceProtocol = DataService()) {
        self.dataService = dataService
    }
    
    func loadData() {
        let url = URL(string: "https://open.er-api.com/v6/latest/USD")!
        dataService.fetchData(from: url) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                exchangeRates = data
                filteredExchangeRates = data
                delegate?.dataManagerDidLoadData() // 데이터 준비가 다 되었음을 알림
            case .failure(let error):
                delegate?.dataManager(didFailWithError: error)
            }
        }
    }
    
    func filterData(searchText: String) {
        // 검색어가 없으면 원본 데이터를 반환하고 리턴
        if searchText.isEmpty {
            filteredExchangeRates = exchangeRates
            delegate?.dataManagerDidFilterData()
            return
        }
        
        // 대소문자 및 문장 맨 앞뒤 공백 무시
        let searchResults = exchangeRates.filter {
            $0.code.localizedStandardContains(searchText.trimmingCharacters(in: .whitespaces)) ||
            $0.country.localizedStandardContains(searchText.trimmingCharacters(in: .whitespaces))
        }
        
        // 검색 결과 반환
        if searchResults.isEmpty {
            filteredExchangeRates = []
        } else {
            filteredExchangeRates = searchResults
        }
        delegate?.dataManagerDidFilterData()
    }
}
