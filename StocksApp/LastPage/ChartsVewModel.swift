//
//  ChartsVewModel.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 02.01.2025.
//

import UIKit

struct PriceDay: Identifiable {
    let id: Int
    let date: Date
    let price: Double
}

struct StockModelChartsPage {
    var ticker: String
    var name: String
    var price: Double
    var change: Double
    var changePercent: Double
    var isFavorite: Bool
}

struct Stock: Codable {
    let timeSeriesDaily: [String: TimeSeriesDaily]

    enum CodingKeys: String, CodingKey {
        case timeSeriesDaily = "Time Series (Daily)"
    }
}

struct TimeSeriesDaily: Codable {
    let the1Open: String
    
    enum CodingKeys: String, CodingKey {
        case the1Open = "1. open"
    }
}

