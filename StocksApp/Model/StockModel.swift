//
//  StockModel.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 15.11.2024.
//
import UIKit

struct StockModel {
    let ticker: String
    let name: String
    var logo: UIImage?
    var price: Double?
    var change: Double?
    var changePercent: Double?
    var favorite: Bool = false
}

struct StockProfilesModel: Codable {
    let name: String
    let logo: String
    let ticker: String
}

struct StockPriceModel: Codable {
    let c: Double
    let d: Double
    let dp: Double
}

struct PriceReturnModel {
    let c: Double
    let d: Double
    let dp: Double
    let ticker: String
}
