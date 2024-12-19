//
//  FavoriteTickers+CoreDataProperties.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 18.12.2024.
//
//

import Foundation
import CoreData


extension FavoriteTickers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteTickers> {
        return NSFetchRequest<FavoriteTickers>(entityName: "FavoriteTickers")
    }

    @NSManaged public var ticker: String?

}

extension FavoriteTickers : Identifiable {

}
