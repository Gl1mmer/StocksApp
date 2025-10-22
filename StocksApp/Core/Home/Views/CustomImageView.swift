//
//  CustomImageView.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 09.12.2024.
//
 
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    var task : URLSessionDataTask!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .scaleAspectFit
        layer.cornerRadius = 12
        backgroundColor = .systemGray5
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadImageFromURL(url: URL) {
        image = nil
        
        if let task = task {
            task.cancel()
        }
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            image = imageFromCache
            return
        }
        
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let logoImage = UIImage(data: data) else {
                print("Could not download an image")
                return
            }
            imageCache.setObject(logoImage, forKey: url.absoluteString as AnyObject)
            DispatchQueue.main.async {
                self.image = logoImage
            }
        }
        task.resume()
    }
}
