//
//  WTRegisterViewController.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 26.11.2023.
//

import UIKit

class WTRegisterViewController: UIViewController {
    
    private let registerModel = WTRegisterViewViewModel()
    private let registerView = WTRegisterView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        
        registerView.delegate = registerModel
        registerModel.delegate = self
    }
    
    private func setupView() {
        view.addSubview(registerView)
        
        NSLayoutConstraint.activate([
            registerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            registerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            registerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            registerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension WTRegisterViewController: WTRegisterViewViewModelDelegate {
    func backToLoginSelected() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didPerformRegistration(receivedResponse: WTRegisterResponse) {
        let alert = UIAlertController(
            title: "Registration successfull!",
            message: "You have been successfully registered",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.registerView.loader.stopLoader()
            self?.present(alert, animated: true)
        }
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
            self?.registerView.loader.stopLoader()
            self?.present(alert, animated: true)
        }
    }
}
