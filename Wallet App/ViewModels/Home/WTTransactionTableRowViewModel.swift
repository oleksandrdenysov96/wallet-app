//
//  WTTransactionTableRowViewModel.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 05.12.2023.
//

import Foundation

final class WTTransactionTableRowViewModel {

    enum RowType: String {
        case date = "Date"
        case type = "Type"
        case category = "Category"
        case comment = "Comment"
        case sum = "Sum"
        case balance = "Balance"
    }

    private let rowType: RowType
    private let value: String

    public var title: String {
        return self.rowType.rawValue
    }
    public var displayValue: String {
        switch rowType {
        case .date:
            return "Undefined"
        default:
            return value
        }
    }

    init(rowType: RowType, value: String) {
        self.rowType = rowType
        self.value = value
    }
}
