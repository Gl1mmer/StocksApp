//
//  ImageDownloaderClass.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 23.11.2024.
//
import UIKit

protocol ImageDownloaderProtocol {
    func downloadImage(from url: StockProfilesModel, completion: @escaping (Result<(UIImage, String), Error>)->Void)
}

final class ImageDownloader: ImageDownloaderProtocol {
     func downloadImage(from url: StockProfilesModel, completion: @escaping (Result<(UIImage, String), Error>)->Void) {
        let ticker = url.ticker
        guard let url = URL(string: url.logo) else {
            completion(.failure(NetworkingError.InvalidURL))
            return
        }
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            guard let data, error == nil else {
                completion(.failure(error!))
                return
            }
            guard let image = UIImage(data: data) else {
                completion(.failure(NetworkingError.couldNotDownloadImage))
                return
            }
            completion(.success((image, ticker)))
        }
        task.resume()
    }
}
