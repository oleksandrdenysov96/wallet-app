//
//  WTCategoriesDetailsCollectionViewCell.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 12.12.2023.
//

import UIKit


class WTCategoriesDetailsCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "WTCategoriesDetailsCollectionViewCell"

    private var tableData: [WTCategoriesDetailsTableViewCellViewModel] = []
    private var totalSums: [String: String] = [:]

    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(
            WTStatisticsDetailsTableViewCell.self,
            forCellReuseIdentifier: WTStatisticsDetailsTableViewCell.cellIdentifier
        )
        table.register(
            WTTableHeaderVieww.self, 
            forHeaderFooterViewReuseIdentifier: WTTableHeaderVieww.identifier
        )
        table.register(
            WTTableFooterView.self,
            forHeaderFooterViewReuseIdentifier: WTTableFooterView.identifier
        )
        table.backgroundColor = .wtMainBackgroundColor
        table.isUserInteractionEnabled = false
        table.allowsSelection = false
        return table
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tableView)
        setupConstraints()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    public func configure(
        with tableData: [WTCategoriesDetailsTableViewCellViewModel],
        totalSums: [String: String]
    ) {
        self.tableData = tableData
        self.totalSums = totalSums
        tableView.reloadData()
    }
}


extension WTCategoriesDetailsCollectionViewCell: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: WTStatisticsDetailsTableViewCell.cellIdentifier,
            for: indexPath
        ) as? WTStatisticsDetailsTableViewCell else {
            SwiftyBeaverConfig.shared.logError("Unable to reuse statistics table cell")
            return UITableViewCell(frame: .zero)
        }
        
        cell.isUserInteractionEnabled = false
        cell.configure(with: tableData[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: WTTableHeaderVieww.identifier
        ) as! WTTableHeaderVieww
        header.frame = CGRect(x: 0, y: 0, width: 300, height: 60)
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: WTTableFooterView.identifier
        ) as! WTTableFooterView
        footer.expenseSum.text = totalSums["expense"]
        footer.incomeSum.text = totalSums["income"]
        footer.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        return footer
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
}
