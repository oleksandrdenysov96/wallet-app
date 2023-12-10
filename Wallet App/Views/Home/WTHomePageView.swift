//
//  WTHomePageView.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 27.11.2023.
//

import UIKit

protocol WTHomePageViewDelegate: AnyObject {
    func didTapAddTransaction()
    func shouldDismissTransactionView()
}

class WTHomePageView: UIView {
    
    public weak var delegate: WTHomePageViewDelegate?

    private let viewModel: WTHomePageViewModel

    private let noResultsView = WTNoResultsView()

    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isHidden = true
        collectionView.alpha = 0

        collectionView.register(
            WTBalanceCollectionViewCell.self,
            forCellWithReuseIdentifier: WTBalanceCollectionViewCell.cellIdentifier
        )
        collectionView.register(
            WTTransactionCollectionViewCell.self,
            forCellWithReuseIdentifier: WTTransactionCollectionViewCell.cellIdentifier
        )
        return collectionView
    }()

    private let floatingButton: UIButton = {
        return WTFloatingButton(frame: .zero)
    }()

    private let loader: WTLoader = {
        return WTLoader(style: .large)
    }()

    init(frame: CGRect, viewModel: WTHomePageViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(
            red: 238/255, green: 238/255, blue: 238/255, alpha: 1
        )
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
        viewModel.delegate = self
        viewModel.fetchTransactions()
        addSubviews(loader, noResultsView, collectionView, floatingButton)
        setupUI()
        loader.startLoader()

        floatingButton.addTarget(
            self, action: #selector(didTapAddTransaction), for: .touchUpInside
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.floatingButton.isHidden = true
        self.floatingButton.alpha = 0

        NSLayoutConstraint.activate([
            noResultsView.topAnchor.constraint(equalTo: topAnchor),
            noResultsView.leftAnchor.constraint(equalTo: leftAnchor),
            noResultsView.rightAnchor.constraint(equalTo: rightAnchor),
            noResultsView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        NSLayoutConstraint.activate([
            loader.heightAnchor.constraint(equalToConstant: 100),
            loader.widthAnchor.constraint(equalToConstant: 100),
            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 110),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])

        NSLayoutConstraint.activate([
            floatingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            floatingButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -120),
            floatingButton.widthAnchor.constraint(equalToConstant: 60),
            floatingButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc
    private func didTapAddTransaction() {
        delegate?.didTapAddTransaction()
    }
}


// MARK: Show collectionView - Model Delegate:
extension WTHomePageView: WTHomePageViewModelDelegate {

    func failedToLoadTransactions() {
        self.loader.stopLoader()

        UIView.animate(withDuration: 0.2) {
            self.noResultsView.isHidden = false
            self.noResultsView.alpha = 1
            self.floatingButton.isHidden = false
            self.floatingButton.alpha = 1
        }
    }
    
    func didLoadTransactions() {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            sectionIndex == 0 ?
            self?.viewModel.createBannerLayout() :
            self?.viewModel.createTransactionLayout()
        }
        collectionView.collectionViewLayout = layout

        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.loader.stopLoader()
            self?.collectionView.isHidden = false
            self?.collectionView.alpha = 1
            self?.floatingButton.isHidden = false
            self?.floatingButton.alpha = 1
        }
        collectionView.reloadData()
    }

    func didLoadAdditionalTransactions(for index: [IndexPath]) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.shouldDismissTransactionView()
            self?.collectionView.performBatchUpdates {
                self?.collectionView.insertItems(at: index)
            }
        }
    }

    func shouldDismissPresentedModal() {
        delegate?.shouldDismissTransactionView()
    }

    func didDeleteTransaction(at index: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.performBatchUpdates({
                self?.collectionView.deleteItems(at: [index])
            })
        }
    }

}
