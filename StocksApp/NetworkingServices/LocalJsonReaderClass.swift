//
//  LocalJsonReaderClass.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 23.11.2024.
//

import UIKit

enum NetworkingError: Error {
    case couldNotReadLocalJSONFile
    case couldNotDownloadImage
    case couldNotGetPriceInfo
    case InvalidURL
}

protocol LocalJsonReaderProtocol {
    func fetchStocks(completion: @escaping (Result<[StockProfilesModel], Error>)->Void)
}

final class LocalJsonReader: LocalJsonReaderProtocol {
   
    func fetchStocks(completion: @escaping (Result<[StockProfilesModel], Error>)->Void) {
        guard let data = readLocalJSONFile(forName: "stockProfiles") else {
            completion(.failure(NetworkingError.couldNotReadLocalJSONFile))
            return
        }
        do {
            let profiles = try JSONDecoder().decode([StockProfilesModel].self, from: data)
            completion(.success(profiles))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func readLocalJSONFile(forName name: String) -> Data? {
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
}
