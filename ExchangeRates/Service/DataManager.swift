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
}

class DataManager {
    weak var delegate: DataManagerDelegate?
    
    private let dataService: DataServiceProtocol
    
    private(set) var exchangeRates: [String: Double] = [:] // 환율정보(예: USD: 1.0000)
    var currencyCodes: [String] = [] // 환율정보 딕셔너리 키값(예: USD)
    var currencyRates: [Double] = [] // 환율정보 딕셔너리 밸류(예: 1.0000)
    
    init(dataService: DataServiceProtocol = DataService()) {
        self.dataService = dataService
    }
    
    func loadData() {
        let url = URL(string: "https://open.er-api.com/v6/latest/USD")!
        dataService.fetchData(from: url) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                // exchangeRates 딕셔너리에 키와 밸류를 저장
                for (key, value) in data.rates {
                    self.exchangeRates.updateValue(value, forKey: key)
                }
                
                // 딕셔너리는 정렬된 상태로 저장을 못하므로, 정렬 후 키와 밸류를 각각의 배열에 저장
                let sortedExchangeRates = exchangeRates.sorted { $0.key < $1.key }
                currencyCodes = sortedExchangeRates.map { $0.key }
                currencyRates = sortedExchangeRates.map { $0.value }
                
                // 데이터 준비가 다 되었음을 알림
                delegate?.dataManagerDidLoadData()
            case .failure(let error):
                delegate?.dataManager(didFailWithError: error)
            }
        }
    }
}
