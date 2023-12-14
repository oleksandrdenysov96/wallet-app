//
//  WTStatisticsViewViewModel.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 11.12.2023.
//

import Foundation
import UIKit
import SwiftUI


protocol WTStatisticsViewViewModelDelegate: AnyObject {
    func didLoadStatisticsData()
}

final class WTStatisticsViewViewModel: NSObject {

    public weak var delegate: WTStatisticsViewViewModelDelegate?

    // MARK: CELLS VIEW MODELS

    private let chartCellViewModel = WTChartViewCellViewModel()
    private let dateSectionViewModel = WTDateSectionCellViewModel()
    private var categoriesDetailsTotalSum: [String: String] = [:]

    // MARK: STATISTICS DATA

    public private(set) var allExpenseData: TotalTypeData?
    public private(set) var allIncomeData: TotalTypeData?
    public private(set) var chartData: [ChartData] = []
    private var categoriesData: [WTCategoriesDetailsTableViewCellViewModel] = []

    public private(set) var statisticsData: WTGetStatistics? {
        didSet {
            guard let totalData = statisticsData?.info else {
                SwiftyBeaverConfig.shared.logError("Failed to retrieve full stat data")
                return
            }
            self.allExpenseData = totalData.expense
            self.allIncomeData = totalData.income

            let expenseCategories = totalData.expense.category
            let monthData: [Int] = [totalData.expense.month]
            let yearData: [Int] = [totalData.expense.year]

            chartCellViewModel.createChartData(data: expenseCategories)
            dateSectionViewModel.defineDateFilteringData(monthData, yearData)

            expenseCategories.forEach { obj in
                guard let categoryType = ExpenseCategories(rawValue: obj.category.lowercased()),
                      let categoryColor = chartCellViewModel.categotyColors[categoryType] else {
                    SwiftyBeaverConfig.shared.logError("Unable to create colors for list section")
                    return
                }
                categoriesData.append(
                    .init(color: categoryColor, category: obj.category, sum: String(obj.sum))
                )
            }
            categoriesDetailsTotalSum = [
                "expense": String(totalData.expense.totalPrice),
                "income": String(totalData.income.totalPrice)
            ]
            delegate?.didLoadStatisticsData()
        }
    }



    override init() {
        super.init()
    }

    
    public func fetchStatistics() {
        let request = WTRequest(endpoint: .categories)

        WTService.shared
            .executeRequest(request,
                            expected: WTGetStatistics.self) { [weak self] result, statusCode in

            switch result {
            case .success(let result):
                self?.statisticsData = result

            case .failure(_):
                if statusCode == 401 {
                    WTService.shared.refreshSession { [weak self] isRefreshed in
                        if isRefreshed {
                            self?.fetchStatistics()
                        }
                        else {
                            SwiftyBeaverConfig.shared.logError(
                                "Failed to refresh sid on statistics"
                            )
                        }
                    }
                }
                else {
                    SwiftyBeaverConfig.shared.logError("Failure")
                }
            }
        }
    }
}

// MARK: COLLECTION VIEW DELEGATE/DATA SOURCE

extension WTStatisticsViewViewModel: UICollectionViewDelegate, 
                                        UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, 
                        numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WTChartsCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? WTChartsCollectionViewCell else {
                SwiftyBeaverConfig.shared.logError("Unable to create chart cell in collectionView")
                fatalError()
            }
            cell.configure(with: chartCellViewModel)
            return cell

        case 1:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WTDateSectionCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? WTDateSectionCollectionViewCell else {
                SwiftyBeaverConfig.shared.logError("Unable to create date section cell in collectionView")
                fatalError()
            }
            cell.configure(with: dateSectionViewModel)
            return cell
            
        case 2:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WTCategoriesDetailsCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? WTCategoriesDetailsCollectionViewCell else {
                SwiftyBeaverConfig.shared.logError("Unable to create date section cell in collectionView")
                fatalError()
            }
            cell.configure(with: categoriesData, totalSums: categoriesDetailsTotalSum)
            return cell
        default:
            break
        }

        SwiftyBeaverConfig.shared.logError("Cell for section \(indexPath.section) cannot be created")
        return UICollectionViewCell()
    }

}


// MARK: COLLECTION VIEW LAYOUT
// TODO: REFACTOR WITH SEPARATE LAYOUT CLASS

extension WTStatisticsViewViewModel {

    public func createChartLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.65)
            ),
            subitems: [item])

        group.contentInsets = NSDirectionalEdgeInsets(
            top: 10, leading: 0, bottom: 0, trailing: 0
        )
        return NSCollectionLayoutSection(group: group)
    }

    public func createDateFiltersLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)
            ),
            subitems: [item])

        group.contentInsets = NSDirectionalEdgeInsets(
            top: 15, leading: 0, bottom: 0, trailing: 0
        )
        return NSCollectionLayoutSection(group: group)
    }

    public func createCategoriesDetailsLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            ),
            subitems: [item])

        group.contentInsets = NSDirectionalEdgeInsets(
            top: 15, leading: 0, bottom: 0, trailing: 0
        )
        return NSCollectionLayoutSection(group: group)
    }
}
