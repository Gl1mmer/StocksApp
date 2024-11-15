//
//  StocksViewModel.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 15.11.2024.
//
import UIKit

final class StocksViewModel {
    
    var listStocks: [StockModel] = []
    
    let stocksNetworkingService = StocksNetworkingService()
    
    var isFetchingEnded: (() -> Void)?

    func fetchStocks() {
        stocksNetworkingService.fetchStocks { result in
            switch result {
                case .success(let stocks):
                self.listStocks = stocks
                DispatchQueue.main.async {
                self.isFetchingEnded?()
                }
                case .failure:
                    print("Error during fetching images")
                    break
            }
        }
    }
    func getStocks() -> [StockModel] {
        listStocks
    }
}
