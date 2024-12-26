//
//  ChartsViewModel.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 25.12.2024.
//

import Foundation

final class ChartsViewModel: ObservableObject {
    
    @Published var ticker: String
    @Published var name: String
    @Published var price: Double
    @Published var change: Double
    @Published var changePercent: Double
    @Published var isFavorite: Bool

    var coreDataManager: CoreDataControl
    
    init(stock: StockModel, coreData: CoreDataControl) {
        ticker = stock.ticker
        name = stock.name
        price = stock.price ?? 0
        change = stock.change ?? 0
        changePercent = stock.changePercent ?? 0
        isFavorite = stock.favorite
        self.coreDataManager = coreData
    }
    
    func favoriteButtonTapped() {
        if isFavorite {
            coreDataManager.removeFavoriteTicker(ticker: ticker)
        } else {
            coreDataManager.saveFavoriteTicker(ticker: ticker)
        }
        isFavorite.toggle()
    }
    
    @Published var prices: [PriceDay] = [
        PriceDay(date: 1, price: 254.77),
        PriceDay(date: 2, price: 218.04),
        PriceDay(date: 3, price: 227.50),
        PriceDay(date: 4, price: 232.16),
        PriceDay(date: 5, price: 200.08),
        PriceDay(date: 6, price: 237.99),
        PriceDay(date: 7, price: 227.82),
        PriceDay(date: 8, price: 216.89),
        PriceDay(date: 9, price: 247.96),
        PriceDay(date: 10, price: 216.89),
        PriceDay(date: 11, price: 251.83),
        PriceDay(date: 12, price: 282.91),
        PriceDay(date: 13, price: 203.99),
        PriceDay(date: 14, price: 222.87),
        PriceDay(date: 15, price: 249.81),
        PriceDay(date: 16, price: 257.27),
        PriceDay(date: 17, price: 264.81),
        PriceDay(date: 18, price: 254.47),
        PriceDay(date: 19, price: 223.33),
        PriceDay(date: 20, price: 211.46),
        PriceDay(date: 21, price: 198.06),
        PriceDay(date: 22, price: 208.88),
        PriceDay(date: 23, price: 208.06),
        PriceDay(date: 24, price: 206.98),
        PriceDay(date: 25, price: 215.25),
        PriceDay(date: 26, price: 216.40),
        PriceDay(date: 27, price: 225.02),
        PriceDay(date: 28, price: 214.01),
        PriceDay(date: 29, price: 204.55),
        PriceDay(date: 30, price: 225.00)
    ]
    
}

// MODEL
struct PriceDay: Identifiable {
    let id = UUID()
    let date: Int
    let price: Double
}
