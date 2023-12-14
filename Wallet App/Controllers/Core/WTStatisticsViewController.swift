//
//  WTStatisticsViewController.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 27.11.2023.
//

import UIKit
import SwiftUI

final class WTStatisticsViewController: UIViewController {

    private let statisticsViewModel: WTStatisticsViewViewModel
    private let statisticsView: WTStatisticView

    init(viewModel: WTStatisticsViewViewModel) {
        self.statisticsViewModel = viewModel
        self.statisticsView = WTStatisticView(
            frame: .zero, viewModel: self.statisticsViewModel
        )
        super.init(nibName: nil, bundle: nil)
        self.setupLogo()
        self.setupNavBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(statisticsView)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            statisticsView.topAnchor.constraint(equalTo: view.topAnchor),
            statisticsView.leftAnchor.constraint(equalTo: view.leftAnchor),
            statisticsView.rightAnchor.constraint(equalTo: view.rightAnchor),
            statisticsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
