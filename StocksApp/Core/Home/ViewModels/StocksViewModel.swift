//
//  StocksViewModel.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 15.11.2024.
//

import UIKit

enum Caller {
    case collectionView, tableView
}

final class StocksViewModel {
    private var listStocks: [StockModel] = []
    
    var isFetchingEnded: (() -> Void)?
    var isUserSearching: Bool = false
    var showFavoriteStocks: Bool = false
    private var searchQuery: String = ""

    private let localJsonReader: LocalJsonReaderProtocol
    private let priceInfoFetcher: PriceInfoFetcherServiceProtocol
    private let coreDataControl: CoreDataControl

    init(
        localJsonReader: LocalJsonReaderProtocol,
        priceInfoFetcher: PriceInfoFetcherServiceProtocol,
        coreDataControl: CoreDataControl
    ) {
        self.localJsonReader = localJsonReader
        self.priceInfoFetcher = priceInfoFetcher
        self.coreDataControl = coreDataControl
    }

    private var filteredStocks: [StockModel] {
        if isUserSearching {
            return listStocks.filter {$0.name.lowercased().hasPrefix(searchQuery.lowercased())}
        } else if showFavoriteStocks {
            return listStocks.filter(\.favorite)
        } else {
            return listStocks
        }
    }
    
    func getStocks(for caller: Caller) -> [StockModel] {
        switch caller {
            case .tableView:
                return filteredStocks
            case .collectionView:
                return listStocks
        }
    }
    
    func getStock(at index: Int, for caller: Caller) -> StockModel {
        switch caller {
            case .tableView:
                let stocks = filteredStocks
                guard index >= 0 && index < stocks.count else {
                    fatalError("Index out of bounds")
                }
                return stocks[index]
            case .collectionView:
                return listStocks[index]
        }
        
    }
    
    func filterStocks(by query: String) {
        searchQuery = query
        isUserSearching = !query.isEmpty
    }
    
    func showFavoriteStocks(_ show: Bool) {
        showFavoriteStocks = show
    }

    func favoriteButtonTapped(_ ticker: String, favorite: Bool) {
        guard let index = listStocks.firstIndex(where: { $0.ticker == ticker })
        else { return }
        listStocks[index].favorite = favorite
        if favorite {
            coreDataControl.saveFavoriteTicker(ticker: ticker)
        } else {
            coreDataControl.removeFavoriteTicker(ticker: ticker)
        }
    }
    
    func updateStockFavorite(ticker: String, favorite: Bool) {
        guard let index = listStocks.firstIndex(where: { $0.ticker == ticker })
        else {
            print("error updating favorite")
            return
        }
        listStocks[index].favorite = favorite
    }
}

extension StocksViewModel {
    func fetchStockData() {
        localJsonReader.fetchStocks { [weak self] result in
            switch result {
            case .success(let profiles):
                for profile in profiles {
                    self?.listStocks.append((self?.createInitialStockModels(profile: profile))!)
                }
                self?.didAppLaunched()
                self?.isFetchingEnded?()
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
    
    func didAppLaunched() {
        let tickers = coreDataControl.fetchFavoriteTickers()
        if !tickers.isEmpty {
            for ticker in tickers {
                guard let index = listStocks.firstIndex(where: { $0.ticker == ticker })
                else {
                    return
                }
                listStocks[index].favorite = true
            }
        }
    }
    
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
