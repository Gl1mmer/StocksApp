//
//  CustomSearchBar.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 11.11.2024.
//

import UIKit

protocol CustomSearchBarDelegate: AnyObject {
    func didBeginEditing()
    func didLeftButtonTapped()
    func showSearchResults(for text: String)
}

final class CustomSearchBar: UIView {
    weak var delegate: CustomSearchBarDelegate?
    
    private lazy var searchTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(
            string: "Find company or ticker",
            attributes: [
                .foregroundColor: UIColor.myColor,
                .font: UIFont.systemFont(ofSize: 14, weight: .regular)])
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return tf
    }()
    
    private lazy var leftButton : UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var rightButton : UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupCornerLine()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCornerLine() {
        layer.cornerRadius = 25
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        clipsToBounds = true
    }
    
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.delegate = self
        
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(searchTextField)
        
        NSLayoutConstraint.activate([
            leftButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftButton.heightAnchor.constraint(equalToConstant: 24),
            leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            leftButton.widthAnchor.constraint(equalToConstant: 24),
            
            rightButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightButton.heightAnchor.constraint(equalToConstant: 24),
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            rightButton.widthAnchor.constraint(equalToConstant: 24),
            
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48),
            searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48),
            searchTextField.topAnchor.constraint(equalTo: topAnchor),
            searchTextField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func leftButtonTapped() {
        delegate?.didLeftButtonTapped()
        searchTextField.resignFirstResponder()
        leftButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        rightButton.isHidden = true
        searchTextField.text = ""
    }
    
    @objc private func rightButtonTapped() {
        searchTextField.text = ""
        rightButton.isHidden = true
        delegate?.didBeginEditing()

    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text == "" {
            rightButton.isHidden = true
            delegate?.didBeginEditing()
        } else {
            rightButton.isHidden = false
            print("searching")
            delegate?.showSearchResults(for: textField.text ?? "Default")
        }
    }
}

extension CustomSearchBar: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        leftButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        delegate?.didBeginEditing()
    }
}

extension UIColor {
    public static var myColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1)
}
