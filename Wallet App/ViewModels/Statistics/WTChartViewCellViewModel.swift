//
//  WTChartViewModel.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 11.12.2023.
//

import Foundation
import SwiftUI

final class WTChartViewCellViewModel {

    public private(set) var categotyColors: [ExpenseCategories: UIColor] = [:]
    public private(set) var chartData: [ChartData]?

    public func createChartData(data: [Category]) {
        let chartData: [ChartData] = data.compactMap { [weak self] category in

            guard let self = self, let currentCategory = ExpenseCategories(
                rawValue: category.category.lowercased()
            ) else {
                SwiftyBeaverConfig.shared.logError("Failed to retrieve color via expense enum")
                fatalError()
            }
            let color = self.setupColor(for: currentCategory)
            self.categotyColors[currentCategory] = UIColor(color)

            return .init(primitivePlottable: category.sum, color: color)
        }
        self.chartData = chartData
    }

    private func setupColor(for category: ExpenseCategories) -> Color {
        switch category {
        case .basic:
            return .blue
        case .food:
            return .orange
        case .car:
            return .gray
        case .tech:
            return .pink
        case .bills:
            return .brown
        case .house:
            return .green
        case .education:
            return .yellow
        }
    }
}
