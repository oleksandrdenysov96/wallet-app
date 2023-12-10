//
//  LoggedUser.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 04.12.2023.
//

import Foundation

struct LoggedUser: Codable {
    let id: String
    let name: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case email
    }
}
