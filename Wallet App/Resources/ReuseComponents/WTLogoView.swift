//
//  WTLogoView.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 16.11.2023.
//

import UIKit

class WTLogoView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLogo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupLogo() {
        backgroundColor = .clear
        image = UIImage(named: "logo")
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func setSize(width: CGFloat = 180, height: CGFloat = 45) {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: height),
        ])
    }

}
