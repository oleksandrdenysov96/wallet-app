//
//  WTChartsCollectionViewCell.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 12.12.2023.
//

import UIKit
import SwiftUI

final class WTChartsCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "WTChartsCollectionViewCell"

    private let statisticsHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Statistics"
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.textColor = .black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints(for view: UIView) {
        NSLayoutConstraint.activate([
            
            statisticsHeaderLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            statisticsHeaderLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            statisticsHeaderLabel.widthAnchor.constraint(equalToConstant: 150),
            statisticsHeaderLabel.heightAnchor.constraint(equalToConstant: 50),

            view.topAnchor.constraint(equalTo: statisticsHeaderLabel.bottomAnchor, constant: 10),
            view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            view.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
    }

    public func configure(with model: WTChartViewCellViewModel) {
        guard let data = model.chartData else {
            SwiftyBeaverConfig.shared.logInfo("data isn't uploaded for statistics yet")
            return
        }
        let hostingViewController = UIHostingController(
            rootView: WTDonutChartView(donutData: data)
        )
        hostingViewController.view.backgroundColor = .clear
        hostingViewController.view
            .translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubviews(statisticsHeaderLabel, hostingViewController.view)
        setupConstraints(for: hostingViewController.view)
        contentView.clipsToBounds = true
    }

}
