//
//  WTTextFieldSeparatorView.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 08.12.2023.
//

import UIKit

class WTTextFieldSeparatorView: UIView {


    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupSeparatorLayout(for textfield: UIView) {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 360),
            self.heightAnchor.constraint(equalToConstant: 0.8),
            self.centerXAnchor.constraint(equalTo: centerXAnchor),
            self.bottomAnchor.constraint(equalTo: textfield.bottomAnchor, constant: -8),

        ])
    }

}
