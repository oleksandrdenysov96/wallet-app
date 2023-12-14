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
        backgroundColor = .wtMainBackgroundColor
        
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
        viewModel.delegate = self
//        viewModel.fetchTransactions()
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

        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.noResultsView.isHidden = false
            self?.noResultsView.alpha = 1
            self?.floatingButton.isHidden = false
            self?.floatingButton.alpha = 1
        }
    }
    
    func didLoadTransactions() {
        guard let isEmptyModels = viewModel.userTransactions?.isEmpty else {
            SwiftyBeaverConfig.shared.logError("Wrong handling empty models state")
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            if isEmptyModels {
                self.failedToLoadTransactions()
            } else {
                collectionView.reloadData()
                let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
                    sectionIndex == 0 ?
                    self.viewModel.createBannerLayout() :
                    self.viewModel.createTransactionLayout()
                }
                self.collectionView.collectionViewLayout = layout

                UIView.animate(withDuration: 0.2) {
                    self.loader.stopLoader()
                    self.collectionView.isHidden = false
                    self.collectionView.alpha = 1
                    self.floatingButton.isHidden = false
                    self.floatingButton.alpha = 1
                }
            }
        }
    }

    func didLoadAdditionalTransactions(for index: [IndexPath]) {
        DispatchQueue.main.async { [weak self] in
            if self?.collectionView.isHidden == true {
                self?.collectionView.reloadData()
                let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
                    sectionIndex == 0 ?
                    self?.viewModel.createBannerLayout() :
                    self?.viewModel.createTransactionLayout()
                }
                self?.collectionView.collectionViewLayout = layout
                self?.initiateCollectionView()
                self?.delegate?.shouldDismissTransactionView()
            }
            else {
                self?.collectionView.reloadData()
                self?.delegate?.shouldDismissTransactionView()
            }
        }
    }

    private func initiateCollectionView() {
        self.collectionView.isHidden = false
        self.collectionView.alpha = 1
        self.noResultsView.isHidden = true
        self.noResultsView.alpha = 0
    }

    func shouldDismissPresentedModal() {
        delegate?.shouldDismissTransactionView()
    }

    func didDeleteTransaction(at index: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            if self?.collectionView.numberOfItems(inSection: 1) == 1 {
                self?.collectionView.performBatchUpdates({
                    self?.collectionView.deleteItems(at: [index])
                })
                self?.hideCollectionViewAndPresentNoResults()
            } else {
                self?.collectionView.performBatchUpdates({
                    self?.collectionView.deleteItems(at: [index])
                })
            }
        }
    }
    

    private func hideCollectionViewAndPresentNoResults() {
        UIView.animate(withDuration: 0.3, animations:  { [weak self] in
            self?.collectionView.alpha = 0
            self?.noResultsView.isHidden = false
            self?.noResultsView.alpha = 1
        }) { [weak self] _ in
            self?.collectionView.isHidden = true
        }
    }
}
