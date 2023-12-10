//
//  WTLoader.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 06.12.2023.
//

import UIKit

class WTLoader: UIActivityIndicatorView {

    override init(style: UIActivityIndicatorView.Style) {
        super.init(style: style)
        translatesAutoresizingMaskIntoConstraints = false
        tintColor = .label
        backgroundColor = .tertiarySystemBackground
        layer.cornerRadius = 10
        hidesWhenStopped = true
        layer.opacity = 0

    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func startLoader() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.layer.opacity = 0.7
            self?.startAnimating()
        }
    }

    public func stopLoader() {
        stopAnimating()
        layer.opacity = 0
    }
}
