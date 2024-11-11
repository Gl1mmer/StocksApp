//
//  CustomSearchBar.swift
//  StocksApp
//
//  Created by Amankeldi Zhetkergen on 11.11.2024.
//

import UIKit

final class CustomSearchBar: UIView {
    private let searchTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(
            string: "Find company or ticker",
            attributes: [
                .foregroundColor: UIColor.myColor,
                .font: UIFont.systemFont(ofSize: 14, weight: .regular)])
        tf.borderStyle = .none
        tf.layer.borderColor = UIColor.black.cgColor
        tf.layer.borderWidth = 1.0
        tf.layer.cornerRadius = 25.0
        tf.leftView = createShiftingView()
        tf.leftViewMode = .always
        tf.clipsToBounds = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(searchTextField)
        
        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchTextField.topAnchor.constraint(equalTo: topAnchor),
            searchTextField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private static func createShiftingView() -> UIView {
        let shiftingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let glassImage = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        glassImage.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        glassImage.tintColor = .black
        glassImage.contentMode = .scaleAspectFit
        glassImage.center = shiftingView.center
        shiftingView.addSubview(glassImage)
        return shiftingView
    }
}

extension UIColor {
    public static var myColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1)
}
