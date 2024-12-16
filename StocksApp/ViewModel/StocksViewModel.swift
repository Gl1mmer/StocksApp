//
//  StocksViewModel.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 15.11.2024.
//
import UIKit

final class StocksViewModel {

    private var listStocks: [StockModel] = []
    private var listFavoriteStocks: [StockModel] = []
    private var listFiltered: [StockModel] = []

    var isFetchingEnded: (() -> Void)?

    private let localJsonReader: LocalJsonReaderProtocol
    private let priceInfoFetcher: PriceInfoFetcherProtocol

    init(
        localJsonReader: LocalJsonReaderProtocol,
        priceInfoFetcher: PriceInfoFetcherProtocol
    ) {
        self.localJsonReader = localJsonReader
        self.priceInfoFetcher = priceInfoFetcher
    }

    func fetchStockData() {
        localJsonReader.fetchStocks { [weak self] result in
            switch result {
            case .success(let profiles):
                self?.fetchPrice(profiles)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchPrice(_ profiles: [StockProfilesModel]) {
        let lock = NSLock()
        let group = DispatchGroup()
        for profile in profiles {
            group.enter()
            listStocks.append(createInitialStockModels(profile: profile))
            priceInfoFetcher.fetchPriceInfo(of: profile.ticker) {
                [weak self] result in
                switch result {
                    case .success(let output):
                        lock.lock()
                        self?.addPriceInfoToStockModel(
                        price: output.c, change: output.d, changePercent: output.dp,
                        ticker: output.ticker)
                        lock.unlock()
                case .failure(let error):
                    print("!!! \(error)")
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.isFetchingEnded?()
        }
    }
    
    var isUserSearching: Bool = false
    var showFavoriteStocks: Bool = false

    func updateFavoriteStocksList() {
        listFavoriteStocks = listStocks.filter(\.favorite)
    }

    func getAllStocks() -> [StockModel] {
        if !isUserSearching {
            if !showFavoriteStocks {
                return listStocks
            } else {
                return listFavoriteStocks
            }
        } else {
            return listFiltered
        }
        
    }

    func getStock(index: Int) -> StockModel {
        if !isUserSearching {
            if !showFavoriteStocks {
                return listStocks[index]
            } else {
                return listFavoriteStocks[index]
            }
        } else {
            return listFiltered[index]
        }
        
    }
    
    func filterStocks(str: String) {
        listFiltered = listStocks.filter { stock in
            stock.name.lowercased().hasPrefix(str.lowercased())
        }
    }

    func favoriteButtonTapped(_ ticker: String) {
        guard let index = listStocks.firstIndex(where: { $0.ticker == ticker })
        else {
            return
        }
        listStocks[index].favorite =
            (listStocks[index].favorite == true) ? false : true
        updateFavoriteStocksList()
    }

    func showFavoriteStocks(_ show: Bool) {
        showFavoriteStocks = show
    }
}

extension StocksViewModel {
    private func createInitialStockModels(profile: StockProfilesModel)
        -> StockModel
    {
        let model = StockModel(
            ticker: profile.ticker, name: profile.name, logoString: profile.logo,
            price: nil, change: nil,
            changePercent: nil)
        return model
    }

    private func addPriceInfoToStockModel(
        price: Double, change: Double, changePercent: Double, ticker: String
    ) {
        guard let index = listStocks.firstIndex(where: { $0.ticker == ticker })
        else {
            return
        }
        listStocks[index].price = price
        listStocks[index].change = change
        listStocks[index].changePercent = changePercent
    }
}
