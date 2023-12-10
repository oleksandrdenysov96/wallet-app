//
//  WTRefreshResponse.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 06.12.2023.
//

import Foundation

struct WTRefreshResponse: Codable {
    let status: String
    let code: Int
    let data: RefreshData
}

struct RefreshData: Codable {
    let sid: String
    let accessToken: String
    let refreshToken: String
}
