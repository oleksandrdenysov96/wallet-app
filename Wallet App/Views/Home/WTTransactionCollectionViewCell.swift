//
//  WTTransactionCollectionViewCell.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 05.12.2023.
//

import UIKit

class WTTransactionCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "WTTransactionCollectionViewCell"

    private var rowModels: [WTTransactionTableRowViewModel] = []
    private var transactionType: String = ""

    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.layer.cornerRadius = 20
        table.contentInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        table.separatorInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        table.isScrollEnabled = false
        table.register(
            WTTransactionTableRowCell.self,
            forCellReuseIdentifier: WTTransactionTableRowCell.rowIdentifier
        )
        return table
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        contentView.layer.cornerRadius = 20

        // Shadows

        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0.3)
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 10

        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setupConstraints()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    public func configure(with viewModel: WTTransactionInfoCellViewModel) {
        self.rowModels = viewModel.transactionDataModels
        self.transactionType = viewModel.tranaction.type
    }

    override func prepareForReuse() {
        tableView.reloadData()
    }
}

extension WTTransactionCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: WTTransactionTableRowCell.rowIdentifier, for: indexPath
        ) as? WTTransactionTableRowCell else {
            fatalError("unable to setup table cell")
        }

        let currentRowModel = self.rowModels[indexPath.row]
        cell.configureRow(
            property: currentRowModel.title,
            value: currentRowModel.displayValue,
            transactionType: self.transactionType)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.frame.height / 6
    }



}
