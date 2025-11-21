//
//  StocksViewModel.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 15.11.2024.
//

import Foundation

protocol StocksViewModelProtocol {
    var onDataUpdated: (() -> Void)? { get set }

    var tableStocks: [StockModel] { get }
    var collectionStocks: [StockModel] { get }
    
    func tableStock(at index: Int) -> StockModel?
    func collectionStock(at index: Int) -> StockModel?

    func fetchStockData()
    func setSearchQuery(_ query: String)
    func clearSearch()
    func setShowingFavorites(_ state: Bool)
    func setFavorite(_ state: Bool, for ticker: String)
}

final class StocksViewModel: StocksViewModelProtocol {
    private var allStocks: [StockModel] = []
    
    var onDataUpdated: (() -> Void)?
    private var isUserSearching: Bool = false
    private var isShowingFavorites: Bool = false
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
    
    var tableStocks: [StockModel] {
        filteredStocks
    }

    var collectionStocks: [StockModel] {
        allStocks
    }
    
    func tableStock(at index: Int) -> StockModel? {
        guard index >= 0 && index < tableStocks.count else { return nil }
        return tableStocks[index]
    }

    func collectionStock(at index: Int) -> StockModel? {
        guard index >= 0 && index < tableStocks.count else { return nil }
        return collectionStocks[index]
    }
    
    private var filteredStocks: [StockModel] {
        if isUserSearching {
            let query = searchQuery.lowercased()
            return allStocks.filter {
                $0.name.lowercased().hasPrefix(query) ||
                $0.ticker.lowercased().hasPrefix(query)
            }
        } else if isShowingFavorites {
            return allStocks.filter { $0.favorite }
        } else {
            return allStocks
        }
    }
    
    func setSearchQuery(_ query: String) {
        searchQuery = query
        isUserSearching = !query.isEmpty
    }
    
    func clearSearch() {
        searchQuery = ""
        isUserSearching = false
    }
    
    func setShowingFavorites(_ state: Bool) {
        isShowingFavorites = state
    }

    func setFavorite(_ state: Bool, for ticker: String) {
        guard let index = allStocks.firstIndex(where: { $0.ticker == ticker }) else {
            print("Could not find a stock with given ticker")
            return
        }
        allStocks[index].favorite = state
        if state {
            coreDataControl.saveFavoriteTicker(ticker: ticker)
        } else {
            coreDataControl.removeFavoriteTicker(ticker: ticker)
        }
    }
}

extension StocksViewModel {
    func fetchStockData() {
        localJsonReader.fetchStocks { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profiles):
                self.allStocks = profiles.map { self.makeStock(from: $0) }
                self.restoreFavorites()
                DispatchQueue.main.async{ self.onDataUpdated?() }
                self.fetchPrice(profiles)
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
            priceInfoFetcher.fetchPriceInfo(of: profile.ticker) { [weak self] result in
                guard let self else {
                    group.leave()
                    return
                }
                switch result {
                    case .success(let output):
                        lock.lock()
                        self.updateStockWithPrice(
                            price: output.c,
                            change: output.d,
                            changePercent: output.dp,
                            ticker: output.ticker
                        )
                        lock.unlock()
                case .failure(let error):
                    print("!!! \(error.localizedDescription)")
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.onDataUpdated?()
        }
    }
    
    func restoreFavorites() {
        let tickers = coreDataControl.fetchFavoriteTickers()
        guard !tickers.isEmpty else { return }
        for ticker in tickers {
                guard let index = allStocks.firstIndex(where: { $0.ticker == ticker }) else {
                    continue
                }
                allStocks[index].favorite = true
            }
    }
    
    private func makeStock(from: StockProfilesModel) -> StockModel {
        let model = StockModel(
                ticker: from.ticker,
                name: from.name,
                logoString: from.logo,
                price: nil,
                change: nil,
                changePercent: nil
            )
        return model
    }

    private func updateStockWithPrice(
        price: Double,
        change: Double,
        changePercent: Double,
        ticker: String
    ) {
        guard let index = allStocks.firstIndex(where: { $0.ticker == ticker })
        else {
            return
        }
        allStocks[index].price = price
        allStocks[index].change = change
        allStocks[index].changePercent = changePercent
    }
}
