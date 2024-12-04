//
//  StocksViewModel.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 15.11.2024.
//
import UIKit

final class StocksViewModel {
    
    private var listStocks: [StockModel] = []
    
    private let stocksNetworkingService = StocksNetworkingService()
    
    var isFetchingEnded: (() -> Void)?
    
    private var showFavoriteStocks: Bool = false

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
    
    func getFavoriteStocks() -> [StockModel] {
        let favoriteStocks = listStocks.filter(\.favorite)
        return favoriteStocks
    }
    
    func getAllStocks() -> [StockModel] {
        if (!showFavoriteStocks) {return listStocks}
        else {return getFavoriteStocks()}
    }
    
    func getStock(index: Int) -> StockModel {
        listStocks[index]
    }
    
    
    func favoriteButtonTapped(_ ticker: String) {
        guard let index = listStocks.firstIndex(where: { $0.ticker == ticker }) else {
            return
        }
        listStocks[index].favorite = (listStocks[index].favorite == true) ? false : true
    }
    
    func showFavoriteStocks(_ show: Bool) {
        self.showFavoriteStocks = show
    }
}
