//
//  WTDateSectionCollectionViewCell.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 12.12.2023.
//

import UIKit

class WTDateSectionCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "WTDateSectionCollectionViewCell"

    private let monthButton: WTDateFilterListViewButton = {
        let button = WTDateFilterListViewButton(
            frame: .zero, buttonTitle: "Month")
        return button
    }()

    private let yearButton: WTDateFilterListViewButton = {
        let button = WTDateFilterListViewButton(
            frame: .zero, buttonTitle: "Year")
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .wtMainBackgroundColor
        contentView.addSubviews(monthButton, yearButton)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            monthButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            monthButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            monthButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),

            yearButton.topAnchor.constraint(equalTo: monthButton.bottomAnchor, constant: 20),
            yearButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            yearButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
        ])
    }

    public func configure(with model: WTDateSectionCellViewModel) {
        guard let monthDropdownData = model.monthDropdownData,
              let yearDropdownData = model.yearDropdownData else {
            SwiftyBeaverConfig.shared.logError("Unable to setup date filters sources")
            return
        }
        monthButton.setupListDataSource(source: monthDropdownData)
        yearButton.setupListDataSource(source: yearDropdownData)
    }
}
