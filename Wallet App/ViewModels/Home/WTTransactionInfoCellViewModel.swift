//
//  WTTransactionInfoCellViewModel.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 04.12.2023.
//

import Foundation

final class WTTransactionInfoCellViewModel {

    enum CellType: String {
        case date = "Date"
        case type = "Type"
        case category = "Category"
        case comment = "Comment"
        case sum = "Sum"
        case balance = "Balance"
    }

    public let tranaction: Transaction

    public var transactionDataModels: [WTTransactionTableRowViewModel] = []

    init(transaction: Transaction) {
        self.tranaction = transaction
        self.setupRowModels()
    }

    private func setupRowModels() {
        transactionDataModels = [
            .init(rowType: .date, value: tranaction.date),
            .init(rowType: .type, value: tranaction.type),
            .init(rowType: .category, value: tranaction.category),
            .init(rowType: .comment, value: tranaction.comment),
            .init(rowType: .sum, value: String(tranaction.sum)),
            .init(rowType: .balance, value: String(tranaction.balance))
        ]
    }
}
