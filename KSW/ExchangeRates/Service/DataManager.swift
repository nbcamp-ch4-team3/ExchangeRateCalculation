//
//  DataManager.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/15/25.
//

import UIKit
import CoreData

protocol DataManagerDelegate: AnyObject {
    func dataManagerDidLoadData()
    func dataManager(didFailWithError error: Error)
    func dataManagerDidFilterData()
}

final class DataManager {
    weak var delegate: DataManagerDelegate?
    
    private let dataService: DataServiceProtocol
    private var container: NSPersistentContainer!
    
    private var currencies: [Currency] = []
    private(set) var filteredCurrencies: [Currency] = []
    private var favorites: [Favorite] = []
    
    init(dataService: DataServiceProtocol = DataService()) {
        self.dataService = dataService
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        container = appDelegate.persistentContainer
    }
    
    // MARK: - 환율 정보(Currency) 관련 메서드
    func loadCurrencies() {
        let url = URL(string: "https://open.er-api.com/v6/latest/USD")!
        dataService.fetchData(from: url) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                currencies = data
                filteredCurrencies = data
                
                delegate?.dataManagerDidLoadData()
            case .failure(let error):
                delegate?.dataManager(didFailWithError: error)
            }
        }
    }
    
    func filterCurrencies(searchText: String) {
        // 검색어가 없으면 원본 데이터를 반환하고 리턴
        if searchText.isEmpty {
            filteredCurrencies = currencies
            sortCurrencies()
            delegate?.dataManagerDidFilterData()
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
        delegate?.dataManagerDidFilterData()
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
    
    // MARK: - 즐겨찾기 관련 메서드
    // 환율 정보 API 수신 후, 즐겨찾기 정보 셋팅
    func prepareFavorites() {
        fetchFavorites()
        registerFavorites()
        sortCurrencies()
    }
    
    // 즐겨찾기 여부 등록
    func registerFavorites() {
//        for index in filteredCurrencies.indices {
//            if favorites.contains(where: { favorite in
//                favorite.currencyCode == filteredCurrencies[index].code
//            }) {
//                filteredCurrencies[index].isFavorite = true
//            }
//        }
        
        for index in currencies.indices {
            if favorites.contains(where: { favorite in
                favorite.currencyCode == currencies[index].code
            }) {
                currencies[index].isFavorite = true
            }
        }
        
        filteredCurrencies = currencies
    }
    
    func toggleFavorite(_ currency: Currency) {
//        let index = filteredCurrencies.firstIndex { $0.code == currency.code }
//        guard let index else { return }
//        
//        filteredCurrencies[index].isFavorite.toggle()
//        
//        if filteredCurrencies[index].isFavorite == true {
//            addFavorite(filteredCurrencies[index])
//        } else {
//            deleteFavorite(filteredCurrencies[index])
//        }
//        
//        sortCurrencies()
        
        
        let index = currencies.firstIndex { $0.code == currency.code }
        guard let index else { return }
        
        currencies[index].isFavorite.toggle()
        
        if currencies[index].isFavorite == true {
            addFavorite(currencies[index])
        } else {
            deleteFavorite(currencies[index])
        }
        
        filteredCurrencies = currencies
        
        sortCurrencies()
    }
    
    // MARK: - 코어 데이터 관련 메서드
    func fetchFavorites() {
        do {
            favorites = try container.viewContext.fetch(Favorite.fetchRequest())
            
            for favorite in favorites as [NSManagedObject] {
                if let currencyCode = favorite.value(forKey: Favorite.Keys.currencyCode) as? String {
                    print("favorite: \(currencyCode)")
                }
            }
        } catch {
            print("fetch error: \(error)")
        }
    }
    
    func addFavorite(_ currency: Currency) {
        guard !isDuplicated(currency) else { return }
        
        guard let entity = NSEntityDescription.entity(forEntityName: Favorite.entityName, in: container.viewContext) else { return }
        let newFavorite = NSManagedObject(entity: entity, insertInto: container.viewContext)
        newFavorite.setValue(currency.code, forKey: Favorite.Keys.currencyCode)
        
        saveContext()
    }
    
    // 즐겨찾기 코어 데이터 저장 시 중복 여부 검사
    private func isDuplicated(_ currency: Currency) -> Bool {
        let request = Favorite.fetchRequest()
        request.predicate = NSPredicate(format: "currencyCode == %@", currency.code)
        
        do {
            let favorites = try container.viewContext.fetch(request)
            
            return favorites.contains { $0.currencyCode == currency.code }
        } catch {
            print("duplicate validation error: \(error)")
        }
        
        return false
    }
    
    func deleteFavorite(_ currency: Currency) {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        request.predicate = NSPredicate(format: "currencyCode == %@", currency.code)
        
        do {
            let favorites = try container.viewContext.fetch(request)
            
            favorites.forEach { container.viewContext.delete($0) }
            
            saveContext()
        } catch {
            print("delete error: \(error)")
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
