//
//  WTTransactionPageViewController.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 07.12.2023.
//

import UIKit


class WTTransactionViewViewController: UIViewController {
    private let homePageViewModel: WTHomePageViewModel
    private let transactionsView: WTTransactionView
    private let transactionsViewViewModel = WTTransactionViewViewModel()


    init(homePageViewModel: WTHomePageViewModel) {
        self.homePageViewModel = homePageViewModel
        self.transactionsView = .init(
            frame: .zero, viewModel: self.transactionsViewViewModel
        )
        super.init(nibName: nil, bundle: nil)
        transactionsViewViewModel.delegate = self.homePageViewModel

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: HANDLE ON APP/SCENE DELEGATE LEVEL
        self.overrideUserInterfaceStyle = .light
        view.addSubview(transactionsView)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            transactionsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            transactionsView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            transactionsView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            transactionsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
