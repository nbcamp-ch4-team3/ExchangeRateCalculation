//
//  MockDataProvider.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/22/25.
//

import Foundation
import Alamofire

class MockDataProvider: NetworkServiceProtocol {
    func fetchData(from url: URL, completion: @escaping (Result<CurrencyResponse, any Error>) -> Void) {
        let response: CurrencyResponse = load("response.json")
        completion(.success(response))
    }
    
    func fetchDataByAlamofire(from url: URL, completion: @escaping (Result<CurrencyResponse, Alamofire.AFError>) -> Void) {}
    
    func load<T: Decodable>(_ filename: String) -> T {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
}
