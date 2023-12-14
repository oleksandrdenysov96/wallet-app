//
//  WTStatisticsDetailsTableViewCell.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 12.12.2023.
//

import UIKit

final class WTStatisticsDetailsTableViewCell: UITableViewCell {
    static let cellIdentifier = "WTStatisticsDetailsTableViewCell"

    private let colorSquare: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black

        view.layer.cornerRadius = 5
        return view
    }()

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .black
        return label
    }()

    private let sumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .black
        label.textAlignment = .right

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .wtMainBackgroundColor
        translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubviews(colorSquare, categoryLabel, sumLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            colorSquare.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            colorSquare.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorSquare.heightAnchor.constraint(equalToConstant: 28),
            colorSquare.widthAnchor.constraint(equalToConstant: 28),

            categoryLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: 100),
            categoryLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            categoryLabel.leftAnchor.constraint(equalTo: colorSquare.rightAnchor, constant: 30),
            categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            sumLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            sumLabel.widthAnchor.constraint(equalToConstant: 50),
            sumLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    public func configure(with dataObj: WTCategoriesDetailsTableViewCellViewModel) {
        colorSquare.backgroundColor = dataObj.color
        categoryLabel.text = dataObj.category
        sumLabel.text = dataObj.sum
    }
}
