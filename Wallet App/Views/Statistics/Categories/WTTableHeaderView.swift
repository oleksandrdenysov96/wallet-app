//
//  WTTableHeaderView.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 13.12.2023.
//

import UIKit

class WTTableHeaderView: UIView {

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.text = "Category"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()

    private let sumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.text = "Sum"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 15
        addSubviews(categoryLabel, sumLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            categoryLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            sumLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            sumLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
