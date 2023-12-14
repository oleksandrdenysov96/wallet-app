//
//  WTHomePageViewModel.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 04.12.2023.
//

import UIKit

protocol WTHomePageViewModelDelegate: AnyObject {
    func didLoadTransactions()
    func failedToLoadTransactions()
    func shouldDismissPresentedModal()
    func didLoadAdditionalTransactions(for index: [IndexPath])
    func didDeleteTransaction(at index: IndexPath)
}

class WTHomePageViewModel: NSObject {

    public weak var delegate: WTHomePageViewModelDelegate?

    public private(set) var userTransactions: [Transaction]? {
        didSet {
            guard let allViewModels = userTransactions else {
                print("Failed to receive transactions")
                return
            }
            guard let lastTransaction = allViewModels.first else {
                return
            }
            LocalState.balance = lastTransaction.balance
        }
    }

    // MARK: API CALLS

    public func fetchTransactions(_ completion: @escaping () -> Void) {
        let request = WTRequest(endpoint: .transactions)

        WTService.shared.executeRequest(request, expected: WTGetAllTransactions.self) { [weak self] result, statusCode in
            guard let self = self else { return }

            switch result {
            case .success(let viewModel):
                self.userTransactions = viewModel.info.reversed()
                self.delegate?.didLoadTransactions()
                completion()

            case .failure(let error):
                if statusCode == 401 {
                    WTService.shared.refreshSession { isRefreshed in
                        if isRefreshed {
                            self.fetchTransactions(completion)
                        }
                        else {
                            SwiftyBeaverConfig.shared.logError("Unable to refresh sid")
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.delegate?.failedToLoadTransactions()
                    }
                    print(error)
                }
            }
        }
    }

    private func fetchAddedTransaction(_ transaction: Transaction) {
        LocalState.balance = transaction.balance
        self.userTransactions?.insert(transaction, at: 0)
    }


    private func deleteSelectedTransaction(at index: IndexPath) {
        guard let transactions = userTransactions else {
            return
        }

        let request = WTRequest(
            endpoint: .transactions,
            httpMethod: .delete, 
            pathComponents: [transactions[index.row].id]
        )

        WTService.shared.executeRequest(
            request, expected: Dictionary<String, String>.self
        ) { [weak self] result, statusCode in

            guard let self = self else { return }

            switch result {
            case .success(_):
                guard let transactions = userTransactions else { return }
                LocalState.balance = transactions[index.row].type == TransactionType.income.rawValue ?
                LocalState.balance - transactions[index.row].sum : LocalState.balance + transactions[index.row].sum

                self.userTransactions?.remove(at: index.row)
                self.delegate?.didDeleteTransaction(at: index)

            case .failure(let error):
                if statusCode == 401 {
                    WTService.shared.refreshSession { isRefreshed in
                        if isRefreshed {
                            self.deleteSelectedTransaction(at: index)
                        }
                        else {
                            SwiftyBeaverConfig.shared.logError(
                                "Unable to refresh session on item deletion"
                            )
                        }
                    }
                }
                else if [500, 502, 503].contains(statusCode) {
                    SwiftyBeaverConfig.shared.logError("Server error")
                }
                else {
                    SwiftyBeaverConfig.shared.logError("Unable to decode model")
                    SwiftyBeaverConfig.shared.logInfo(String(describing: error))

                }
            }
        }
    }
}


// MARK: COLLECTIONVIEW DELEGATE

extension WTHomePageViewModel: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let transactions = userTransactions else { return 0 }
        return section == 0 ? 1 : transactions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WTBalanceCollectionViewCell.cellIdentifier, for: indexPath
            ) as? WTBalanceCollectionViewCell else {
                fatalError("Unable to setup balance cell")
            }
            cell.configure(with: String(LocalState.balance))
            return cell
        }
        else {
            guard let transactions = userTransactions,
                  let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WTTransactionCollectionViewCell.cellIdentifier, for: indexPath
            ) as? WTTransactionCollectionViewCell else {
                fatalError("Unable to setup balance cell")
            }
            cell.configure(with: .init(transaction: transactions[indexPath.row]))
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, 
                        contextMenuConfigurationForItemsAt indexPaths: [IndexPath],
                        point: CGPoint) -> UIContextMenuConfiguration? {
        
        let isLastSection = indexPaths.allSatisfy { $0.section == 1 }
        guard isLastSection, let firstIndex = indexPaths.first else {
            return  nil
        }

        let configuration = UIContextMenuConfiguration(actionProvider: { actions -> UIMenu? in
            let deleteAction = UIAction(
                title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive
            ) { [weak self] action in
                self?.deleteSelectedTransaction(at: firstIndex)
            }
            return UIMenu(
                options: [.displayInline],
                children: [deleteAction]
            )
        })
        return configuration
    }
}


// MARK: COLLECTIONVIEW LAYOUT

extension WTHomePageViewModel {

    public func createBannerLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(215)
            ),
            subitems: [item])

        group.contentInsets = NSDirectionalEdgeInsets(
            top: 60, leading: 15, bottom: 40, trailing: 15
        )
        return NSCollectionLayoutSection(group: group)
    }

    public func createTransactionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0), 
                heightDimension: .fractionalHeight(1.0)
            )
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(400)
            ),
            subitems: [item])
        
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 15, leading: 15, bottom: 15, trailing: 15
        )
        return NSCollectionLayoutSection(group: group)
    }
}


// MARK: NEW TRANSACTION VIEW HANDLER

extension WTHomePageViewModel: WTTransactionViewViewModelDelegate {
    func didPostTransaction(_ transaction: Transaction) {
        fetchAddedTransaction(transaction)
        let indexForInsert = IndexPath(row: 0, section: 1)
        delegate?.didLoadAdditionalTransactions(for: [indexForInsert])
    }

    func didTapCancel() {
        delegate?.shouldDismissPresentedModal()
    }
}
