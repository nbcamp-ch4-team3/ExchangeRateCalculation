//
//  DataService.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/15/25.
//

import Foundation

protocol DataServiceProtocol {
    func fetchData(from url: URL, completion: @escaping (Result<[Currency], Error>) -> Void)
}

final class DataService: DataServiceProtocol {
    enum DataError: Error {
        case noData
        case responseFailed
        case parsingFailed
    }
    
    func fetchData(from url: URL, completion: @escaping (Result<[Currency], Error>) -> Void) {
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
                let response = try JSONDecoder().decode(CurrencyResponse.self, from: data)
                var currencies: [Currency] = []
                
                // 파싱한 데이터 딕셔너리(rates)의 키와 밸류를 각각 코드(예: USD)와 환율(예: 1.0000)에 넣고, 국가명을 매핑(예: 미국)
                for (key, value) in response.rates {
                    let currency = Currency(code: key, country: countryCodes[key] ?? "", rate: value)
                    currencies.append(currency)
                }
                
                // 코드 기준 정렬
                currencies.sort { $0.code < $1.code }
                
                completion(.success(currencies))
            } catch {
                completion(.failure(DataError.parsingFailed))
            }
        }
        
        task.resume()
    }
}
