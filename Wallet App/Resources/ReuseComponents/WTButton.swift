//
//  WTButton.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 16.11.2023.
//

import UIKit

class WTButton: UIButton {
    
    public var customBackgroundColor: UIColor = UIColor.clear {
        didSet {
            backgroundColor = customBackgroundColor
        }
    }
    
    public var customTextColor: UIColor = UIColor.black {
        didSet {
            setTitleColor(customTextColor, for: .normal)
        }
    }
    
    public var customText: String = "PLACEHOLDER" {
        didSet {
            setTitle(customText, for: .normal)
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupButton(title: String, color: UIColor?, textColor: UIColor?, withBorder: Bool = false) {
        self.customText = title
        
        if let color, let textColor {
            self.customBackgroundColor = color
            self.customTextColor = textColor
        }
        if withBorder {
            layer.borderColor = UIColor.wtMainBlue.cgColor
            layer.borderWidth = 1.3
        }
    }
    
    private func setupDefaults() {
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont(name: "Circe-Regular", size: 100) ?? UIFont.systemFont(ofSize: 20)
        setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        layer.cornerRadius = 20
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func setSize(width: CGFloat = 320, height: CGFloat = 60) {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: height),
        ])
    }
    
}
