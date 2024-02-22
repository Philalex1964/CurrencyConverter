//
//  CurrencyService.swift
//  CurrencyConverter
//
//  Created by Alexander Filippov on 21.2.24..
//

import Foundation

class CurrencyService {
    static let shared = CurrencyService()
    private let apiKey = "fca_live_8rxirK8CEbm7c4eyf0z2yHQWB9sqa1xQHS8Bzfv0" 
    
    func fetchCurrencyRates(completion: @escaping (Result<[String: Double], Error>) -> Void) {
        let urlString = "https://api.freecurrencyapi.com/v1/latest?apikey=\(apiKey)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let currencyResponse = try decoder.decode(CurrencyResponse.self, from: data)
                completion(.success(currencyResponse.data))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
}
    
struct CurrencyResponse: Codable {
    let data: [String: Double]
}
