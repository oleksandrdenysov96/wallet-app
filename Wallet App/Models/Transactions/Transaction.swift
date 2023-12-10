//
//  Transaction.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 04.12.2023.
//

import Foundation

struct Transaction: Codable {
    let id: String
    let date: String
    let type: String
    let category: String
    let comment: String
    let sum: Int
    let balance: Int
    let owner: LoggedUser

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case date
        case type
        case category
        case comment
        case sum
        case balance
        case owner
    }
}
