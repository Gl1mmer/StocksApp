//
//  CustomCollectionViewCell.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 11.12.2024.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: CustomCollectionViewCell.self)
    
    private let stockNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Some text"
        label.font = .montserrat(.regular, size: 12)
        label.textColor = .label
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemGray5
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ text: String) {
        if let firstWord = text.components(separatedBy: [" " , "."]).first {
            stockNameLabel.text = firstWord
        }
    }
    private func setup() {
        contentView.addSubview(stockNameLabel)
        
        NSLayoutConstraint.activate([
            stockNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            stockNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            stockNameLabel.topAnchor.constraint(equalTo: topAnchor),
            stockNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
