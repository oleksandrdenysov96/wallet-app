//
//  WTNoResultsView.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 05.12.2023.
//

import UIKit

class WTNoResultsView: UIView {

    private let iconView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.tintColor = UIColor(red: 0.29, green: 0.34, blue: 0.89, alpha: 1)
        view.image = UIImage(systemName: "note.text.badge.plus")
        return view
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 23, weight: .semibold)
        label.textColor = UIColor(red: 0.43, green: 0.47, blue: 0.91, alpha: 1)
        label.text = "Transactions will be shown here"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        isHidden = true
        alpha = 0
        addSubviews(iconView, label)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 180),
            iconView.heightAnchor.constraint(equalToConstant: 180),
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 300),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),

            label.leftAnchor.constraint(equalTo: leftAnchor),
            label.rightAnchor.constraint(equalTo: rightAnchor),
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
            label.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 30),

        ])
    }
}
