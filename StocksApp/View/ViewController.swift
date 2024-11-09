//
//  ViewController.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 09.11.2024.
//

import UIKit

final class ViewController: UIViewController {
    
    private let searchTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "Find company or ticker", attributes: [.foregroundColor: UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1), .font: UIFont.systemFont(ofSize: 14, weight: .regular)])
        tf.borderStyle = .none
        tf.layer.borderColor = UIColor.black.cgColor
        tf.layer.borderWidth = 1.0
        tf.layer.cornerRadius = 25.0
        
        let shiftingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: tf.frame.height))
        let glassImage = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        glassImage.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        glassImage.tintColor = .black
        glassImage.contentMode = .scaleAspectFit
        glassImage.center = shiftingView.center
        shiftingView.addSubview(glassImage)
        tf.leftView = shiftingView
        tf.leftViewMode = .always
        
        tf.clipsToBounds = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let companiesTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .systemGray5
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(searchTextField)
        view.addSubview(companiesTableView)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 68),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 48),
            
            companiesTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 18),
            companiesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            companiesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            companiesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }


}

