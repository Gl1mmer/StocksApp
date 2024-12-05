//
//  PriceInfoFetcherClass.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 23.11.2024.
//

import UIKit

protocol PriceInfoFetcherProtocol {
    func fetchPriceInfo(of ticker: String, completion: @escaping (Result<(PriceReturnModel), Error>)->Void)
}

final class PriceInfoFetcher: PriceInfoFetcherProtocol {
      func fetchPriceInfo(of ticker: String, completion: @escaping (Result<(PriceReturnModel), Error>)->Void) {
        let ticker = ticker
        guard let url = URL(string: "https://finnhub.io/api/v1/quote?token=csri4e1r01qhtrfn4ue0csri4e1r01qhtrfn4ueg&symbol=\(ticker)") else {
            completion(.failure(NetworkingError.InvalidURL))
            return
        }
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            guard let data, error == nil else {
                completion(.failure(error!))
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(StockPriceModel.self, from: data)
                completion(.success(PriceReturnModel(c: decodedData.c, d: decodedData.d, dp: decodedData.dp, ticker: ticker)))
            } catch {
                completion(.failure(NetworkingError.couldNotGetPriceInfo))
            }
        }
        task.resume()
    }
}
