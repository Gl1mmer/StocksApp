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
    
    var isFetchingEnded: (() -> Void)?
    var isFetchingPriceEnded: (() -> Void)?

    private let LocalJsonReader: LocalJsonReaderProtocol
    private let ImageDownloader: ImageDownloaderProtocol
    private let PriceInfoFetcher: PriceInfoFetcherProtocol

    init(
        LocalJsonReader: LocalJsonReaderProtocol,
        ImageDownloader: ImageDownloaderProtocol,
        PriceInfoFetcher: PriceInfoFetcherProtocol
    ) {
        self.LocalJsonReader = LocalJsonReader
        self.ImageDownloader = ImageDownloader
        self.PriceInfoFetcher = PriceInfoFetcher
    }

    func fetchStockData() {
        LocalJsonReader.fetchStocks { [weak self] result in
            switch result {
            case .success(let profiles):
                self?.processProfiles(profiles)
            case .failure(let error):
                print(error)
            }
        }
    }

    private func processProfiles(_ profiles: [StockProfilesModel]) {
        let group = DispatchGroup()
        let lock = NSLock()

        for profile in profiles {
            let initialModel = createInitialStockModels(profile: profile)
            listStocks.append(initialModel)
            group.enter()
            ImageDownloader.downloadImage(from: profile) { [weak self] result in
                switch result {
                case .success((let image, let ticker)):
                    lock.lock()
                    self?.addImageToStockModel(image: image, ticker: ticker)
                    lock.unlock()
                case .failure(_):
                    print("cannot download Image")
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.isFetchingEnded?()
        }
    }
    
    func fetchStockPrice() {
        let group = DispatchGroup()
        let lock = NSLock()
        
        for stock in listStocks {
            group.enter()
            PriceInfoFetcher.fetchPriceInfo(of: stock.ticker) { [weak self] result in
                switch result {
                    case .success(let output):
                        lock.lock()
                        self?.addPriceInfoToStockModel(price: output.c, change: output.d, changePercent: output.dp, ticker: output.ticker)
                        lock.unlock()
                    case .failure(let error):
                        print("!!! \(error)")
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.isFetchingPriceEnded?()
        }
    }
    
    var showFavoriteStocks: Bool = false

    func updateFavoriteStocksList() {
        listFavoriteStocks = listStocks.filter(\.favorite)
    }

    func getAllStocks() -> [StockModel] {
        if !showFavoriteStocks {
            return listStocks
        } else {
            return listFavoriteStocks
        }
    }

    func getStock(index: Int) -> StockModel {
        if !showFavoriteStocks {
            return listStocks[index]
        } else {
            return listFavoriteStocks[index]
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
    private func createInitialStockModels(profile: StockProfilesModel) -> StockModel {
        let model = StockModel(
            ticker: profile.ticker, name: profile.name,
            logo: UIImage(systemName: "questionmark"), price: nil, change: nil,
            changePercent: nil)
        return model
    }

    private func addImageToStockModel(image: UIImage, ticker: String) {
        guard let index = listStocks.firstIndex(where: { $0.ticker == ticker })
        else {
            return
        }
        listStocks[index].logo = image
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
