//
//  PriceHistoryNetworkingClass.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 09.01.2025.
//

import UIKit

protocol PriceHistoryNetworkingProtocol {
    func fetchPriceHistory(of ticker: String, completion: @escaping (Result<(Stock), Error>)->Void)
}

final class PriceHistoryNetworkingClass: PriceHistoryNetworkingProtocol {
    func fetchPriceHistory(of ticker: String, completion: @escaping (Result<(Stock), Error>)->Void) {
        guard let url = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=\(ticker)&apikey=EPANGJROXIT9WU8L") else {
            return completion(.failure(NetworkingError.invalidURL))
        }
        
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            guard let data, error == nil else {
                completion(.failure(error!))
                return
            }
            print(data)
            do {
                let decodedData = try JSONDecoder().decode(Stock.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(NetworkingError.couldNotGetPriceInfo))
            }
        }
        task.resume()
    }
}
