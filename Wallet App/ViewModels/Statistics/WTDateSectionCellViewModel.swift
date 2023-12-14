//
//  WTDateSectionViewViewModel.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 12.12.2023.
//

import Foundation


final class WTDateSectionCellViewModel {

    public private(set) var monthDropdownData: [String]?
    public private(set) var yearDropdownData: [String]?


    public func defineDateFilteringData(_ months: [Int], _ years: [Int]) {
        monthDropdownData = months.sorted().compactMap({
            return String($0)
        })
        yearDropdownData = years.sorted().compactMap({
            return String($0)
        })

    }
}
