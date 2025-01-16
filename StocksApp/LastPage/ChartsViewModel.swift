//
//  ChartsViewModel.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 25.12.2024.
//
import Foundation

final class ChartsViewModel: ObservableObject {
    
    @Published var dataModel : StockModelChartsPage
    @Published var isShowAlert: Bool = false
    @Published var isBoughtStock: Bool = false
    var prices: [PriceDay] = []
    @Published var pricesPerPeriod: [PriceDay] = []
    var coreDataManager: CoreDataControl
    var priceHistoryDownloader: PriceHistoryNetworkingProtocol
    
    let dataConverter = dataConverterClass()
    
    init(stock: StockModel, coreData: CoreDataControl, priceHistoryNetworking: PriceHistoryNetworkingProtocol) {
        self.dataModel = StockModelChartsPage(
                    ticker: stock.ticker,
                    name: stock.name,
                    price: stock.price ?? 0,
                    change: stock.change ?? 0,
                    changePercent: stock.changePercent ?? 0,
                    isFavorite: stock.favorite
                )
        self.coreDataManager = coreData
        self.priceHistoryDownloader = priceHistoryNetworking
    }
    
    func favoriteButtonTapped() {
        if dataModel.isFavorite {
            coreDataManager.removeFavoriteTicker(ticker: dataModel.ticker)
        } else {
            coreDataManager.saveFavoriteTicker(ticker: dataModel.ticker)
        }
        dataModel.isFavorite.toggle()
    }
    
    func fetchHistoryPrice() {
        priceHistoryDownloader.fetchPriceHistory(of: dataModel.ticker) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let historialPrices):
                    self?.prices = historialPrices.timeSeriesDaily.map { date, dailyData in
                        PriceDay(
                            id: self?.dataConverter.getIndex() ?? 0,
                            date: self?.dataConverter.convertStringToDate(date) ?? Date(),
                            price: Double(dailyData.the1Open) ?? 0.0
                        )
                    }
                    self?.pricesPerPeriod = self!.prices
                case .failure(let error):
                    print("\(error) !!!")
                }
            }
        }
    }
    
    func getPriceForPeriod(of period: String) {
        var count = 0;
        if period == "D" {
            count = 1
        } else if period == "3D" {
            count = 3
        } else if period == "W" {
            count = 7
        } else if period == "2W" {
            count = 14
        } else if period == "M" {
            count = 30
        } else if period == "All" {
            count = prices.count
        }
        let reducedPrices = Array(prices.suffix(count))
        pricesPerPeriod = reducedPrices.enumerated().map { index, priceDay in
            PriceDay(id: index, date: priceDay.date, price: priceDay.price)
        }
    }
    
    func getPriceForIndex(of index: Int) -> String {
        let price = pricesPerPeriod[index].price
        return "$\(String(format: "%.2f", price))"
    }
    
    func getDateForIndex(of index: Int) -> String {
        return dataConverter.convertDateToString(pricesPerPeriod[index].date)
    }
    
}

final class dataConverterClass {
    var index = -1
    
    let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter
        }()
    
    let dateFormatterWithTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter
    }()
        
    func convertStringToDate(_ string: String) -> Date {
        return dateFormatter.date(from: string) ?? Date()
    }
    
    func convertDateToString(_ date: Date) -> String {
        return dateFormatterWithTime.string(from: date)
    }
    
    func getIndex() -> Int {
        index += 1
        return index
        
    }
}
