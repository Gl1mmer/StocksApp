//
//  NetworkingErrors.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 09.01.2025.
//

import Foundation

enum NetworkingError: Error {
    case couldNotReadLocalJSONFile
    case couldNotDownloadImage
    case couldNotGetPriceInfo
    case invalidURL
}
