//
//  WTLoginViewController.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 15.11.2023.
//

import UIKit

protocol WTLoginViewControllerDelegate: AnyObject {
    func didLoggedIntoSystem(with model: WTLoginResponse)
}

class WTLoginViewController: UIViewController {
    
    private let loginView: WTLoginView = WTLoginView()
    private let loginViewModel = WTLoginViewViewModel()
    
    public weak var delegate: WTLoginViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        loginView.delegate = loginViewModel
        loginViewModel.delegate = self
    }
    
    
    func setupView() {
        view.addSubview(loginView)
        
        NSLayoutConstraint.activate([
            loginView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loginView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loginView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loginView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

extension WTLoginViewController: WTLoginViewViewModelDelegate {

    func registrationStarted() {
        let registerViewController = WTRegisterViewController()
        navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    func enteredWrongCreds(errTitle: String, errMessage: String) {
        let alert = UIAlertController(
            title: errTitle,
            message: errMessage,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.loginView.loader.stopLoader()
            self?.present(alert, animated: true)
        }
    }
    
    
    func didPerformLogin(receivedResponse: WTLoginResponse) {
        delegate?.didLoggedIntoSystem(with: receivedResponse)
        
        DispatchQueue.main.async { [weak self] in
            self?.loginView.loader.stopLoader()
            RootViewControllerFactory().makeHomeScreenMainAfterLogin()
        }
    }
}
