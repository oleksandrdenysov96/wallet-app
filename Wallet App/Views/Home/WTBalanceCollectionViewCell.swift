//
//  WTBalanceCollectionViewCell.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 05.12.2023.
//

import UIKit

class WTBalanceCollectionViewCell: UICollectionViewCell {

    static let cellIdentifier = "WTBalanceCollectionViewCell"

    private let container: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .white
        container.layer.cornerRadius = 35
//        container.layer.shadowColor = UIColor.black.cgColor
//        container.layer.shadowOffset = CGSize(width: 0, height: 0.6)
//        container.layer.shadowOpacity = 0.1
//        container.layer.shadowRadius = 5
        return container
    }()

    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(
            red: 0.651, green: 0.651, blue: 0.651, alpha: 1
        )
        label.font = UIFont(name: "Circe-Regular", size: 12) ?? UIFont.systemFont(ofSize: 18)
        label.text = "Your balance".uppercased()
        return label
    }()

    private let balanceValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(
            red: 0, green: 0, blue: 0, alpha: 1
        )
        label.font = UIFont(name: "Poppins-Regular", size: 30) ?? UIFont.systemFont(ofSize: 43, weight: .bold)
        label.text = "₴ 0"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false

        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0.3)
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 10

        contentView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        contentView.layer.cornerRadius = 35
        contentView.clipsToBounds = true


        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(container)
        container.addSubview(stackView)
        stackView.addArrangedSubview(balanceLabel)
        stackView.addArrangedSubview(balanceValueLabel)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 5

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            container.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 15),
            stackView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 40),
            stackView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -15),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),

            balanceLabel.heightAnchor.constraint(equalToConstant: 30),
            balanceLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            balanceValueLabel.heightAnchor.constraint(equalToConstant: 40),
            balanceValueLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])
    }

    public func configure(with viewModelBalanceLabel: String) {
        balanceValueLabel.text = "₴ \(viewModelBalanceLabel)"
    }
}
