//
//  DataService.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/15/25.
//

import Foundation

protocol DataServiceProtocol {
    func fetchData(from url: URL, completion: @escaping (Result<ExchangeRate, Error>) -> Void)
}

class DataService: DataServiceProtocol {
    enum DataError: Error {
        case noData
        case responseFailed
        case parsingFailed
    }
    
    func fetchData(from url: URL, completion: @escaping (Result<ExchangeRate, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            let successRange = 200..<300
            guard let response = response as? HTTPURLResponse,
                  successRange.contains(response.statusCode)
            else {
                completion(.failure(DataError.responseFailed))
                return
            }
            
            guard let data else {
                completion(.failure(DataError.noData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(ExchangeRate.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(DataError.parsingFailed))
            }
        }
        
        task.resume()
    }
}
