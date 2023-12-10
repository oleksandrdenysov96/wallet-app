//
//  WTPostedTransactionResponse.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 09.12.2023.
//

import Foundation

struct WTPostedTransactionResponse: Codable {
    let date: String
    let type: String
    let category: String
    let comment: String
    let sum: Int
    let balance: Int
}
