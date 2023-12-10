//
//  WTTransactionTableRowCell.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 05.12.2023.
//

import UIKit

class WTTransactionTableRowCell: UITableViewCell {

    static let rowIdentifier = "WTTransactionTableRowCell"

    private let propertiesContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.97)
        return container
    }()

    private let propertyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        label.textColor = .black
        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()

    private let rowLeadingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBlue
        return view
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        contentView.addSubviews(propertiesContainer)
        setupConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        propertyLabel.text = nil
        valueLabel.text = nil
        rowLeadingView.backgroundColor = nil
    }

    public func configureRow(property: String, value: String, transactionType: String) {
        self.isUserInteractionEnabled = false
        propertyLabel.text = property
        valueLabel.text = value

        rowLeadingView.backgroundColor = transactionType
            .elementsEqual("income") ?
        UIColor(red: 0.14, green: 0.8, blue: 0.65, alpha: 1) :
        UIColor(red: 1, green: 0.4, blue: 0.59, alpha: 1)
    }

    private func setupConstraints() {
        propertiesContainer.addSubviews(rowLeadingView, propertyLabel, valueLabel)

        NSLayoutConstraint.activate([
            propertiesContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            propertiesContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            propertiesContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            propertiesContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            rowLeadingView.leadingAnchor.constraint(equalTo: propertiesContainer.leadingAnchor),
            rowLeadingView.heightAnchor.constraint(equalTo: propertiesContainer.heightAnchor),
            rowLeadingView.widthAnchor.constraint(equalToConstant: 6),

            propertyLabel.centerYAnchor.constraint(equalTo: propertiesContainer.centerYAnchor),
            propertyLabel.leftAnchor.constraint(equalTo: propertiesContainer.leftAnchor, constant: 25),
            valueLabel.centerYAnchor.constraint(equalTo: propertiesContainer.centerYAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: propertiesContainer.trailingAnchor, constant: -25)
        ])
    }
}
