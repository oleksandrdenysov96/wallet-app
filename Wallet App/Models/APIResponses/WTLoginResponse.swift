//
//  LoggedUser.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 25.11.2023.
//

import Foundation


struct WTLoginResponse: Codable {
    let status: String
    let code: Int
    let data: UserData
}
