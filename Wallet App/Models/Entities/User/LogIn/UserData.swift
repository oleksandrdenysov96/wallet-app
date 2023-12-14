//
//  UserData.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 25.11.2023.
//

import Foundation

struct UserData: Codable {
    let sid, accessToken, refreshToken: String
    let user: User
}
