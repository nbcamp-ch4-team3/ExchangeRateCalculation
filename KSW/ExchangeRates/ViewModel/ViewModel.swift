//
//  ViewModel.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/15/25.
//

import UIKit
import CoreData

protocol ViewModelDelegate: AnyObject {
    func viewModelDidLoadData()
    func viewModel(didFailWithError error: Error)
    func viewModelDidFilterData()
}

final class ViewModel {
    weak var delegate: ViewModelDelegate?
    
    private let networkService: NetworkServiceProtocol
    private var container: NSPersistentContainer!
    
    private var currencies: [Currency] = []
    private(set) var filteredCurrencies: [Currency] = []
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        container = appDelegate.persistentContainer
    }
    
    func loadCurrencies() {
        fetchCurrencies()
        
        let url = URL(string: "https://open.er-api.com/v6/latest/USD")!
        networkService.fetchData(from: url) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                var count = 0
                var new = 0
                for (key, value) in response.rates {
                    if let index = currencies.firstIndex(where: { $0.code == key }) {
                        currencies[index].rate = value
                        count += 1
                    } else {
                        let currency = Currency(context: container.viewContext)
                        currency.code = key
                        currency.country = countryCodes[key] ?? ""
                        currency.rate = value
                        currency.isFavorite = false
                        currencies.append(currency)
                        
                        new += 1
                    }
                }
                print("count: \(count)")
                print("new: \(new)")
                
                saveContext()
                
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
        
        saveContext()
        
        filteredCurrencies = currencies
        sortCurrencies()
    }
    
    func fetchCurrencies() {
        do {
            currencies = try container.viewContext.fetch(Currency.fetchRequest())
            print("fetch count: \(currencies.count)")
        } catch {
            print("fetch error: \(error)")
        }
    }
    
    private func saveContext () {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
