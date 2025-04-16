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

final class DataManager {
    weak var delegate: DataManagerDelegate?
    
    private let dataService: DataServiceProtocol
    private(set) var exchangeRates: [ExchangeRate] = []
    
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
                delegate?.dataManagerDidLoadData() // 데이터 준비가 다 되었음을 알림
            case .failure(let error):
                delegate?.dataManager(didFailWithError: error)
            }
        }
    }
}
