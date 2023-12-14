//
//  WTTableHeaderVieww.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 13.12.2023.
//

import UIKit

class WTTableHeaderVieww: UITableViewHeaderFooterView {
    static let identifier = "WTTableHeaderVieww"

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.text = "Category"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    private let sumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.text = "Sum"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()


    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 25
        contentView.addSubviews(categoryLabel, sumLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: widthAnchor),
            categoryLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17),

            sumLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            sumLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17),
//            sumLabel.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
}
