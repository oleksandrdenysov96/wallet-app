//
//  WTTableFooterView.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 14.12.2023.
//

import UIKit

class WTTableFooterView: UITableViewHeaderFooterView {
    static let identifier = "WTTableFooterView"

    private let expenseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.text = "Expenses:"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    private let incomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.text = "Income:"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()


    public let expenseSum: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .wtActionRed
        label.textAlignment = .center
        return label
    }()

    public let incomeSum: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .wtActionGreen
        label.textAlignment = .center
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .wtMainBackgroundColor
        contentView.addSubviews(incomeLabel, expenseLabel, incomeSum, expenseSum)
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
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            expenseLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25),
            expenseLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            expenseSum.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -25),
            expenseSum.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),


            incomeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25),
            incomeLabel.topAnchor.constraint(equalTo: expenseLabel.bottomAnchor, constant: 25),
            incomeSum.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -25),
            incomeSum.topAnchor.constraint(equalTo: expenseSum.bottomAnchor, constant: 25),
        ])
    }

}
