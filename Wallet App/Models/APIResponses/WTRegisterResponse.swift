//
//  WTRegisterResponse.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 26.11.2023.
//

import Foundation

struct WTRegisterResponse: Codable {
    let status: String
    let code: Int
    let data: DataClass
}

struct DataClass: Codable {
    let user: User
}
