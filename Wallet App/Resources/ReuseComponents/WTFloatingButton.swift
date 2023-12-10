//
//  WTFloatingButton.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 06.12.2023.
//

import UIKit

class WTFloatingButton: UIButton {

    init(frame: CGRect, cornerRadius: CGFloat = 30) {
        super.init(frame: frame)
        setTitle("+", for: .normal)
        titleLabel?.font = .systemFont(ofSize: 35, weight: .regular)
        backgroundColor = .wtActionGreen
        tintColor = UIColor.white
        layer.cornerRadius = cornerRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 4
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
