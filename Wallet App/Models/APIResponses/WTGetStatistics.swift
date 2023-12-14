//
//  WTGetStatistics.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 11.12.2023.
//

import Foundation

struct WTGetStatistics: Codable {
    let info: StatisticObject
}


struct StatisticObject: Codable {
    let statusCode: Int
    let message: String
    let expense: TotalTypeData
    let income: TotalTypeData
}
