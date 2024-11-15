//
//  StocksNetworkingService.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 15.11.2024.
//

import UIKit

enum error1: Error {
    case couldNotReadLocalJSONFile
    case couldNotDownloadImage
    case couldNotGetPriceInfo
    case InvalidURL
}

final class StocksNetworkingService {
    var stocks: [StockModel] = []
    
    func fetchStocks(completion: @escaping (Result<[StockModel], Error>)->Void) {
        guard let data = readLocalJSONFile(forName: "stockProfiles") else {
            completion(.failure(error1.couldNotReadLocalJSONFile))
            return
        }
        let lock = NSLock()
        do {
            let profiles = try JSONDecoder().decode([StockProfilesModel].self, from: data)
            for profile in profiles {
                createInitialStockModels(profile: profile)
            }
            let dg = DispatchGroup()
            for profile in profiles {
                dg.enter()
                downloadImage(from: profile) { result in
                    switch result {
                    case .success((let image, let ticker)):
                        lock.lock()
                        self.addImageToStockModel(image: image, ticker: ticker)
                        lock.unlock()
                    case .failure(let error):
                        print(error)
                    }
                    dg.leave()
                }
                dg.enter()
                fetchPriceInfo(of: profile) { result in
                    switch result {
                    case .success((let c, let d, let dp, let ticker)):
                        lock.lock()
                        self.addPriceInfoToStockModel(price: c, change: d, changePercent: dp, ticker: ticker)
                        lock.unlock()
                    case .failure(let error):
                        print(error)
                    }
                    dg.leave()
                }
            }
            dg.notify(queue: .main) {
                completion(.success(self.stocks))
            }
        } catch {
            completion(.failure(error))
        }
    }

    func readLocalJSONFile(forName name: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            }
        } catch {
            print("error: \(error)")
        }
        return nil
    }
    
    func downloadImage(from url: StockProfilesModel, completion: @escaping (Result<(UIImage, String), Error>)->Void) {
        let ticker = url.ticker
        guard let url = URL(string: url.logo) else {
            completion(.failure(error1.InvalidURL))
            return
        }
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            guard let data, error == nil else {
                completion(.failure(error!))
                return
            }
            guard let image = UIImage(data: data) else {
                completion(.failure(error1.couldNotDownloadImage))
                return
            }
            completion(.success((image, ticker)))
        }
        task.resume()
    }
    
    private func fetchPriceInfo(of profile: StockProfilesModel, completion: @escaping (Result<(Double, Double, Double, String), Error>)->Void) {
        let ticker = profile.ticker
        guard let url = URL(string: "https://finnhub.io/api/v1/quote?token=csri4e1r01qhtrfn4ue0csri4e1r01qhtrfn4ueg&symbol=\(ticker)") else {
            completion(.failure(error1.InvalidURL))
            return
        }
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            guard let data, error == nil else {
                completion(.failure(error!))
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(StockPriceModel.self, from: data)
                completion(.success((decodedData.c, decodedData.d, decodedData.dp, ticker)))
            } catch {
                completion(.failure(error1.couldNotGetPriceInfo))
            }
        }
        task.resume()
    }
    
    private func createInitialStockModels(profile: StockProfilesModel) {
        let model = StockModel(ticker: profile.ticker, name: profile.name, logo: UIImage(systemName: "questionmark"), price: nil, change: nil, changePercent: nil)
        stocks.append(model)
    }
    
    private func addImageToStockModel(image: UIImage, ticker: String) {
        guard let index = stocks.firstIndex(where: { $0.ticker == ticker }) else {
            return
        }
        stocks[index].logo = image
    }
    
    private func addPriceInfoToStockModel(price: Double, change: Double, changePercent: Double, ticker: String) {
        guard let index = stocks.firstIndex(where: { $0.ticker == ticker }) else {
            return
        }
        stocks[index].price = price
        stocks[index].change = change
        stocks[index].changePercent = changePercent
    }
}
