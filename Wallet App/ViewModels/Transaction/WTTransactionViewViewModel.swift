//
//  WTTransactionViewViewModel.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 08.12.2023.
//

import Foundation

protocol WTTransactionViewViewModelDelegate: AnyObject {
    func didPostTransaction(_ transaction: Transaction)
    func didTapCancel()
}

enum  TransactionType: String {
    case income = "income"
    case expense = "expense"
}

enum ExpenseCategories: String, CaseIterable {
    case basic = "basic"
    case food = "food"
    case car = "car"
    case tech = "tech"
    case bills = "bills"
    case house = "house"
    case education = "education"
}

enum IncomeCategories: String, CaseIterable {
    case basic = "basic"
    case salary = "salary"
    case onlyFans = "onlyFans"
    case bonuses = "bonuses"
    case debts = "debts"
}

final class WTTransactionViewViewModel {

    public weak var delegate: WTTransactionViewViewModelDelegate?

    public func postTransactionWith(type: String, category: String, date: String, sum: Int, comment: String?) {
        let request = WTRequest(endpoint: .transactions, httpMethod: .post)
        guard let balance = LocalState.balance else {
            print("Current balance isn't defined in local state")
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"

        guard let dateFromString = dateFormatter.date(from: date) else {
            print("Couldn't receive date from string")
            return
        }
        dateFormatter.dateFormat = "E MMM dd yyyy HH:mm:ss"
        let formattedDate = dateFormatter.string(from: dateFromString)

        let body: [String: Any] = [
            "date": formattedDate,
            "type": type,
            "category": category,
            "comment": comment != nil ? comment! : "–",
            "sum": sum,
            "balance": balance + sum
        ]
        WTService.shared.executeRequest(request,
                                        body: WTService.shared.requestBody(body: body),
                                        accessToken: LocalState.accessToken,
                                        expected: WTGetAllTransactions.self) { [weak self] result, statusCode in

            guard let self = self else {return}
            switch result {
            case .success(let transaction):
                self.delegate?.didPostTransaction(transaction.info.first!)

            case .failure(let failure):
                if statusCode == 401 {
                    WTService.shared.refreshSession { isRefreshed in
                        if isRefreshed {
                            self.postTransactionWith(
                                type: type, category: category, 
                                date: date, sum: sum, comment: comment
                            )
                        }
                        else {
                            print("-- UNABLE TO REFRESH SID ON POST TRANSACTION --")

                            // MARK: PRESENT ALERT
                        }
                    }
                }
                else {
                    print("–––––––––––––––––––––")
                    print("-- UNABLE TO DECODE RESPONSE --")
                    print("-- INFO: --")
                    print("-- CODE: \(String(describing: statusCode)) --")
                    print("-- CODE: \(failure) --")
                }
            }
        }
    }

    public func handleCancelAction() {
        delegate?.didTapCancel()
    }
}
