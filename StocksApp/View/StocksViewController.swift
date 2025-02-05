//
//  ViewController.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 09.11.2024.
//

import UIKit
import SwiftUI

final class StocksViewController: UIViewController {
    
    private let coreDataControl = CoreDataControl()
    
    private lazy var model = StocksViewModel(localJsonReader: LocalJsonReader(), priceInfoFetcher: PriceInfoFetcher(), coreDataControl: coreDataControl)

    private let searchTextField = CustomSearchBar()
    
    private lazy var searchEmptyView = SearchEmptyView(delegate: self)
        
    private let companiesTableView: UITableView = {
        let tv = UITableView()
        tv.register(StockCell.self, forCellReuseIdentifier: StockCell.identifier)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private let buttonsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stocksButton: UIButton = {
        let button  = UIButton()
        button.setTitle("Stocks", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .montserrat(.bold, size: 28)
        button.addTarget(self, action: #selector(stocksButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var favouriteButton: UIButton = {
        let button  = UIButton()
        button.setTitle("Favourite", for: .normal)
        button.setTitleColor(.systemGray4, for: .normal)
        button.titleLabel?.font = .montserrat(.bold, size: 18)
//        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.addTarget(self, action: #selector(favouritesButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let labelButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
        
    private let stocksLabel: UILabel = {
        let label = UILabel()
        label.text = "Stocks"
        label.textColor = .label
        label.font = .montserrat(.bold, size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var showMoreButton: UIButton = {
        let button  = UIButton()
        button.setTitle("Show more", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .montserrat(.semibold, size: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableViewDelegateConfiguration()
        model.fetchStockData()
        addSearchEmptyView()
        model.isFetchingEnded = {
            self.companiesTableView.reloadData()
        }
    }

    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(searchTextField)
        view.addSubview(companiesTableView)
        view.addSubview(buttonsView)
        buttonsView.addSubview(stocksButton)
        buttonsView.addSubview(favouriteButton)
                
        searchTextField.delegate = self
        view.bringSubviewToFront(searchTextField)
                
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 48),
            
            buttonsView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20),
            buttonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsView.heightAnchor.constraint(equalToConstant: 32),
            
            stocksButton.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor),
            stocksButton.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor, constant: 0),
            
            favouriteButton.leadingAnchor.constraint(equalTo: stocksButton.trailingAnchor, constant: 20),
            favouriteButton.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor, constant: 0),
            
            companiesTableView.topAnchor.constraint(equalTo: buttonsView.bottomAnchor, constant: 8), // 20
            companiesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            companiesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            companiesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func addSearchEmptyView() {
        view.addSubview(searchEmptyView)
        
        view.addSubview(labelButtonView)
        labelButtonView.addSubview(stocksLabel)
        labelButtonView.addSubview(showMoreButton)
                    
        NSLayoutConstraint.activate([
            labelButtonView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20),
            labelButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            labelButtonView.heightAnchor.constraint(equalToConstant: 32),
            
            stocksLabel.leadingAnchor.constraint(equalTo: labelButtonView.leadingAnchor),
            stocksLabel.centerYAnchor.constraint(equalTo: labelButtonView.centerYAnchor),
            
            showMoreButton.trailingAnchor.constraint(equalTo: labelButtonView.trailingAnchor),
            showMoreButton.centerYAnchor.constraint(equalTo: labelButtonView.centerYAnchor),

            searchEmptyView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 32),
            searchEmptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchEmptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchEmptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func tableViewDelegateConfiguration() {
        companiesTableView.delegate = self
        companiesTableView.dataSource = self
    }
    
    @objc private func stocksButtonTapped() {
        stocksButton.titleLabel?.font = .montserrat(.bold, size: 28)
        stocksButton.setTitleColor(.black, for: .normal)
        favouriteButton.titleLabel?.font = .montserrat(.bold, size: 18)
        favouriteButton.setTitleColor(.systemGray4, for: .normal)
        model.showFavoriteStocks(false)
        companiesTableView.reloadData()
    }

    @objc private func favouritesButtonTapped() {
        favouriteButton.titleLabel?.font = .montserrat(.bold, size: 28)
        favouriteButton.setTitleColor(.black, for: .normal)
        stocksButton.titleLabel?.font = .montserrat(.bold, size: 18)
        stocksButton.setTitleColor(.systemGray4, for: .normal)
        model.showFavoriteStocks(true)
        companiesTableView.reloadData()
    }
    
    private func openNextPage(_ stock: StockModel) {
        let nextView = StockDetailView(stock: stock, coreData: coreDataControl) { favorite in
            self.model.updateStockFavorite(ticker: stock.ticker, favorite: favorite)
            self.companiesTableView.reloadData()
        }
        let hostingController = UIHostingController(rootView: nextView)
        hostingController.modalPresentationStyle = .fullScreen
        present(hostingController, animated: true, completion: nil)
    }
}

extension StocksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getStocks(for: .tableView).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.identifier, for: indexPath) as? StockCell else {
            fatalError("Could not dequeue cell [1]")
        }
        if let url = URL(string: model.getStock(at: indexPath.row, for: .tableView).logoString) {
            cell.companySymbolImageView.loadImageFromURL(url: url)
        }
        cell.configure(info: model.getStock(at: indexPath.row, for: .tableView), index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stock = model.getStock(at: indexPath.row, for: .tableView)
        openNextPage(stock)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        68
    }
}

extension StocksViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.getStocks(for: .collectionView).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else { fatalError("Error dequeueing cell") }
        cell.configure(model.getStock(at: indexPath.row, for: .collectionView).name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let stock = model.getStock(at: indexPath.row, for: .collectionView)
        openNextPage(stock)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension StocksViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 40)
    }
}

extension StocksViewController: StockCellDelegate {
    func favoriteButtonTapped(of ticker: String, favoriteState: Bool) {
        model.updateStockFavorite(ticker: ticker, favorite: favoriteState)
        companiesTableView.reloadData()
    }
}

extension StocksViewController: CustomSearchBarDelegate {
    func showSearchResults(for text: String) {
        model.isUserSearching = true
        model.filterStocks(by: text)
        searchEmptyView.isHidden = true
        labelButtonView.isHidden = false
        companiesTableView.isHidden = false
        companiesTableView.reloadData()
    }
    
    func didLeftButtonTapped() {
        searchEmptyView.isHidden = true
        labelButtonView.isHidden = true
        companiesTableView.isHidden = false
        buttonsView.isHidden = false
        model.isUserSearching = false
        companiesTableView.reloadData()
    }
    
    func didBeginEditing() {
        searchEmptyView.isHidden = false
        labelButtonView.isHidden = true
        companiesTableView.isHidden = true
        buttonsView.isHidden = true
    }
}
