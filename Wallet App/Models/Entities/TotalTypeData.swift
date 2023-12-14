//
//  TotalTypeData.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 11.12.2023.
//

import Foundation

struct TotalTypeData: Codable {
    let month, year: Int
    let totalPrice: Int
    let category: [Category]
}

// MARK: - Category
struct Category: Codable {
    let category: String
    let sum: Int
}
