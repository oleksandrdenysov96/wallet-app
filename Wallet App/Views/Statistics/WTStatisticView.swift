//
//  WTStatisticView.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 11.12.2023.
//

import UIKit

final class WTStatisticView: UIView {

    private let viewModel: WTStatisticsViewViewModel

    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(
            WTChartsCollectionViewCell.self,
            forCellWithReuseIdentifier: WTChartsCollectionViewCell.cellIdentifier
        )
        collectionView.register(
            WTDateSectionCollectionViewCell.self,
            forCellWithReuseIdentifier: WTDateSectionCollectionViewCell.cellIdentifier
        )
        collectionView.register(
            WTCategoriesDetailsCollectionViewCell.self,
            forCellWithReuseIdentifier: WTCategoriesDetailsCollectionViewCell.cellIdentifier
        )
        collectionView.isHidden = true
        collectionView.alpha = 0
        return collectionView
    }()

    private let loader: WTLoader = {
        return WTLoader(style: .large)
    }()


    // MARK: INIT()

    init(frame: CGRect, viewModel: WTStatisticsViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        viewModel.delegate = self
        backgroundColor = .wtMainBackgroundColor
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(loader, collectionView)
        setupConstraints()
        loader.startLoader()

        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setupConstraints() {

        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor),
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

extension WTStatisticView: WTStatisticsViewViewModelDelegate {
    func didLoadStatisticsData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }

            collectionView.reloadData()
            let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
                switch sectionIndex {
                case 0:
                    return self.viewModel.createChartLayout()
                case 1:
                    return self.viewModel.createDateFiltersLayout()
                case 2:
                    return self.viewModel.createCategoriesDetailsLayout()
                default:
                    break
                }
                SwiftyBeaverConfig.shared.logError("Unable to create layout")
                return nil
            }
            self.collectionView.collectionViewLayout = layout
            self.loader.stopLoader()

            UIView.animate(withDuration: 0.2) {
                self.collectionView.isHidden = false
                self.collectionView.alpha = 1
            }
        }
    }
}
