//
//  CoreDataControl.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 24.12.2024.
//

import UIKit
import CoreData

final class CoreDataControl {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func fetchFavoriteTickers() -> [String] {
        do {
            let favorites = try context.fetch(FavoriteTickers.fetchRequest())
            return favorites.map(\.ticker!)
        } catch {
            print("can't fetch favorite tickers")
        }
        print("fetched favorite tickers")
        return []
    }
    
    func saveFavoriteTicker(ticker: String) {
        let newFavStock = FavoriteTickers(context: context)
        newFavStock.ticker = ticker
        
        do {
            try context.save()
        } catch {
            print("can't save favorite ticker")
        }
        print("saved favorite ticker: \(ticker)")
    }
    
    func removeFavoriteTicker(ticker: String) { // from ChatGPT
        let fetchRequest: NSFetchRequest<FavoriteTickers> = FavoriteTickers.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "ticker == %@", ticker)

            do {
                let results = try context.fetch(fetchRequest)
                if let favoriteToRemove = results.first {
                    context.delete(favoriteToRemove)
                    try context.save()
                    print("Removed favorite ticker: \(ticker)")
                } else {
                    print("Ticker not found: \(ticker)")
                }
            } catch {
                print("Failed to remove favorite ticker: \(error)")
            }
    }
    
}
