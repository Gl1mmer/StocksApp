//
//  ViewController.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 09.11.2024.
//
import UIKit

final class StocksViewController: UIViewController {
    private let searchTextField = CustomSearchBar()
    
    let model = StocksViewModel()
    
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
        view.backgroundColor = .white
        setupUI()
        tableViewDelegateConfiguration()
        model.fetchStocks()
        
        model.isFetchingEnded = {
            self.companiesTableView.reloadData()
        }
    }
    
    private func setupUI() {
        view.addSubview(searchTextField)
        view.addSubview(companiesTableView)
        view.addSubview(buttonsView)
        buttonsView.addSubview(stocksButton)
        buttonsView.addSubview(favouriteButton)
                
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

    private func tableViewDelegateConfiguration() {
        companiesTableView.delegate = self
        companiesTableView.dataSource = self
    }
    
    @objc private func stocksButtonTapped() {
        stocksButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        stocksButton.setTitleColor(.black, for: .normal)
        favouriteButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        favouriteButton.setTitleColor(.systemGray4, for: .normal)
    }

    @objc private func favouritesButtonTapped() {
        favouriteButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        favouriteButton.setTitleColor(.black, for: .normal)
        stocksButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        stocksButton.setTitleColor(.systemGray4, for: .normal)
    }
}

extension StocksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getStocks().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.identifier, for: indexPath) as? StockCell else {
            fatalError("Could not dequeue cell [1]")
        }
        cell.configure(info: model.getStocks()[indexPath.row], index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        68
    }
}
