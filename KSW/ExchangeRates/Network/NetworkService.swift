//
//  NetworkService.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/15/25.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    func fetchData(from url: URL, completion: @escaping (Result<CurrencyResponse, Error>) -> Void)
    func fetchDataByAlamofire(from url: URL, completion: @escaping (Result<CurrencyResponse, AFError>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    enum DataError: Error {
        case noData
        case responseFailed
        case parsingFailed
    }
    
    func fetchData(from url: URL, completion: @escaping (Result<CurrencyResponse, Error>) -> Void) {
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
                completion(.success(response))
            } catch {
                completion(.failure(DataError.parsingFailed))
            }
        }
        
        task.resume()
    }
    
    // Alamofire 사용
    func fetchDataByAlamofire(from url: URL, completion: @escaping (Result<CurrencyResponse, AFError>) -> Void) {
        AF.request(url).validate().responseDecodable(of: CurrencyResponse.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
