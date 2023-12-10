//
//  WTTextField.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 25.11.2023.
//

import UIKit

class WTTextField: UITextField {
    
    public var customTextColor: UIColor = UIColor.black {
        didSet {
            textColor = customTextColor
        }
    }
    
    public var customText: String = "PLACEHOLDER" {
        didSet {
            text = customText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupTextField(placeholder: String, textColor: UIColor = UIColor.gray,
                               isSecureField: Bool = false) {
        
        let attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: textColor,
                .font: UIFont(name: "Circe-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18)
            ]
        )
        self.attributedPlaceholder = attributedPlaceholder
        self.isSecureTextEntry = isSecureField
    }
    
    private func setupDefaults() {
        backgroundColor = .clear
        textColor = .black
        translatesAutoresizingMaskIntoConstraints = false
    
    }
    
    public func setSize(width: CGFloat = 320, height: CGFloat = 60) {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: height),
        ])
    }
    
}
