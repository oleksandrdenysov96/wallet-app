//
//  WTHomePageViewController.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 27.11.2023.
//

import UIKit


class WTHomePageViewController: UIViewController {

    private let homePageView: WTHomePageView
    private let homePageViewModel: WTHomePageViewModel

    init(viewModel: WTHomePageViewModel) {
        self.homePageViewModel = viewModel
        
        self.homePageView = WTHomePageView(
            frame: .zero, viewModel: self.homePageViewModel
        )
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.setupLogo()
        self.setupNavBar()

        homePageView.delegate = self
    }
}

// MARK: Layout base
extension WTHomePageViewController {
    
    private func setupView() {
        view.addSubview(homePageView)
        
        NSLayoutConstraint.activate([
            homePageView.topAnchor.constraint(equalTo: view.topAnchor),
            homePageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            homePageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            homePageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension WTHomePageViewController: WTHomePageViewDelegate {
    func shouldDismissTransactionView() {
        self.dismiss(animated: true)
    }
    
    func didTapAddTransaction() {
        let transactionViewController = WTTransactionViewViewController(
            homePageViewModel: homePageViewModel
        )
        self.present(transactionViewController, animated: true)
    }
    

}
