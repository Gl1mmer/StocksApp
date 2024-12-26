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
    
    private lazy var searchEmptyView = SearchEmptyView(model: model)
        
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
        button.titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        button.addTarget(self, action: #selector(stocksButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var favouriteButton: UIButton = {
        let button  = UIButton()
        button.setTitle("Favourite", for: .normal)
        button.setTitleColor(.systemGray4, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.addTarget(self, action: #selector(favouritesButtonTapped), for: .touchUpInside)
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
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 68),
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
            
            companiesTableView.topAnchor.constraint(equalTo: buttonsView.bottomAnchor, constant: 20),
            companiesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            companiesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            companiesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func addSearchEmptyView() {
        view.addSubview(searchEmptyView)
            
        NSLayoutConstraint.activate([
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
        stocksButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        stocksButton.setTitleColor(.black, for: .normal)
        favouriteButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        favouriteButton.setTitleColor(.systemGray4, for: .normal)
        model.showFavoriteStocks(false)
        companiesTableView.reloadData()
    }

    @objc private func favouritesButtonTapped() {
        favouriteButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        favouriteButton.setTitleColor(.black, for: .normal)
        stocksButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        stocksButton.setTitleColor(.systemGray4, for: .normal)
        model.showFavoriteStocks(true)
        companiesTableView.reloadData()
    }
    
    private func openNextPage(_ stock: StockModel) {
        let nextView = SwiftUIView(stock: stock, coreData: coreDataControl) { favorite in
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
        return model.getAllStocks().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.identifier, for: indexPath) as? StockCell else {
            fatalError("Could not dequeue cell [1]")
        }
        if let url = URL(string: model.getStock(index: indexPath.row).logoString) {
            cell.companySymbolImageView.loadImageFromURL(url: url)
        }
        cell.configure(info: model.getStock(index: indexPath.row), index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stock = model.getStock(index: indexPath.row)
        openNextPage(stock)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        68
    }
}

extension StocksViewController: StockCellDelegate {
    func favoriteButtonTapped(of ticker: String) {
        model.favoriteButtonTapped(ticker)
        companiesTableView.reloadData()
    }
}

extension StocksViewController: CustomSearchBarDelegate {
    func showSearchResults(for text: String) {
        model.filterStocks(str: text)
        searchEmptyView.isHidden = true
        companiesTableView.isHidden = false
        companiesTableView.reloadData()
    }
    
    func didLeftButtonTapped() {
        buttonsView.isHidden = false
        companiesTableView.isHidden = false
        searchEmptyView.isHidden = true
        model.isUserSearching = false
        companiesTableView.reloadData()
    }
    
    func didBeginEditing() {
        buttonsView.isHidden = true
        companiesTableView.isHidden = true
        searchEmptyView.isHidden = false
        model.isUserSearching = true
    }
}
