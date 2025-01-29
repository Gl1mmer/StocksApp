//
//  SearchEmptyView.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 15.12.2024.
//

import UIKit

final class SearchEmptyView: UIView {
    private let popularLabel: UILabel = {
        let label = UILabel()
        label.text = "Popular requests"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let popularStocksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 8
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private let recentLabel: UILabel = {
        let label = UILabel()
        label.text = "You’ve searched for this"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let recentStocksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 8
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    
    init(delegate: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout) {
        super.init(frame: .zero)
        self.setupUI()
        popularStocksCollectionView.delegate = delegate
        popularStocksCollectionView.dataSource = delegate
        recentStocksCollectionView.delegate = delegate
        recentStocksCollectionView.dataSource = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(popularLabel)
        addSubview(popularStocksCollectionView)
        addSubview(recentLabel)
        addSubview(recentStocksCollectionView)
        
        NSLayoutConstraint.activate([
            popularLabel.topAnchor.constraint(equalTo: topAnchor),
            popularLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            popularStocksCollectionView.topAnchor.constraint(equalTo: popularLabel.bottomAnchor, constant: 11),
            popularStocksCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            popularStocksCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            popularStocksCollectionView.heightAnchor.constraint(equalToConstant: 88),
            
            recentLabel.topAnchor.constraint(equalTo: popularStocksCollectionView.bottomAnchor, constant: 28),
            recentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            recentStocksCollectionView.topAnchor.constraint(equalTo: recentLabel.bottomAnchor, constant: 11),
            recentStocksCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            recentStocksCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            recentStocksCollectionView.heightAnchor.constraint(equalToConstant: 88),
        ])
    }
}
