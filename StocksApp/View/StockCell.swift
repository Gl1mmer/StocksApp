//
//  StockCell.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 12.11.2024.
//

import UIKit

protocol StockCellDelegate: AnyObject {
    func favoriteButtonTapped(of ticker: String)
}

class StockCell: UITableViewCell {
    static let identifier = String(describing: StockCell.self)
    
    weak var delegate: StockCellDelegate?
    
    private var companySymbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "questionmark")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .systemGray5
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let companyNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Default"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.tintColor = .systemGray4
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let companyAddInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Default"
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "???"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dayDeltaLabel: UILabel = {
        let label = UILabel()
        label.text = "???"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        layer.cornerRadius = 16
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error: init(coder:) has not been implemented")
    }
    
    func configure(info: StockModel, index: Int) {
        backgroundColor = (index % 2 == 0) ? .systemGray6 : .white
        companySymbolImageView.image = info.logo
        companyNameLabel.text = info.ticker
        companyAddInfoLabel.text = info.name
        guard let currentPrice = info.price, let dayDelta = info.change, let changePercentage = info.changePercent else { return }
        currentPriceLabel.text = String(format: "$%.2f", currentPrice)
        dayDeltaLabel.textColor = (dayDelta > 0) ? .systemGreen : .systemRed
        dayDeltaLabel.text = (dayDelta > 0) ? String(format: "+$%.2f (%.2f%%)", abs(dayDelta), abs(changePercentage)) : String(format: "-$%.2f (%.2f%%)", abs(dayDelta), abs(changePercentage))
        favoriteButton.tintColor = (info.favorite == false) ? .systemGray4 : .systemOrange

    }
    
    @objc private func favoriteButtonTapped() {
        guard let cellTicker = companyNameLabel.text else { return }
        delegate?.favoriteButtonTapped(of: cellTicker)
    }

    private func setupUI() {
        contentView.addSubview(companySymbolImageView)
        contentView.addSubview(companyNameLabel)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(companyAddInfoLabel)
        contentView.addSubview(currentPriceLabel)
        contentView.addSubview(dayDeltaLabel)
        
        NSLayoutConstraint.activate([
            companySymbolImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            companySymbolImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            companySymbolImageView.heightAnchor.constraint(equalToConstant: 52),
            companySymbolImageView.widthAnchor.constraint(equalToConstant: 52),
            
            companyNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 72),
            companyNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            
            favoriteButton.leadingAnchor.constraint(equalTo: companyNameLabel.trailingAnchor, constant: 6),
            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            favoriteButton.widthAnchor.constraint(equalToConstant: 16),
            favoriteButton.heightAnchor.constraint(equalToConstant: 16),
            
            companyAddInfoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 72),
            companyAddInfoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 38),
            
            currentPriceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            currentPriceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17),
            
            dayDeltaLabel.topAnchor.constraint(equalTo: topAnchor, constant: 38),
            dayDeltaLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17)
        ])
    }
}
