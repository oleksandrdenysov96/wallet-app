//
//  WTLoginView.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 15.11.2023.
//

import UIKit

protocol WTLoginViewDelegate: AnyObject {
    func wTLoginView(_ loginView: WTLoginView, receivedUserEmail email: String,
                     receivedUserPassword password: String)
    
    func didTypeWrongCredentials()
    
    func didSelectRegisterButton()
}

class WTLoginView: UIView {
    
    private var viewModel: WTLoginViewViewModel = WTLoginViewViewModel()
    
    public weak var delegate: WTLoginViewDelegate?
    
    private let logoView: WTLogoView = {
        return WTLogoView(frame: .zero)
    }()
    
    private let emailField: WTTextField = {
        let textField = WTTextField()
        textField.setupTextField(placeholder: "   Email")
        textField.returnKeyType = .done
        return textField
    }()
    
    private let passwordField: WTTextField = {
        let textField = WTTextField()
        textField.setupTextField(placeholder: "   Password", isSecureField: true)
        return textField
    }()
    
    private let loginButton: WTButton = {
        let button = WTButton()
        button.setupButton(
            title: "LOGIN",
            color: UIColor(
                red: 0.141, green: 0.8, blue: 0.655, alpha: 1
            ),
            textColor: .white)

        return button
    }()
    
    private let registerButton: WTButton = {
        let button = WTButton()
        button.setupButton(
            title: "REGISTER",
            color: UIColor(
                red: 1, green: 1, blue: 1, alpha: 1
            ),
            textColor: UIColor(
                red: 0.29, green: 0.337, blue: 0.886, alpha: 1
            ),
            withBorder: true)
        return button
    }()

    public let loader: WTLoader = {
        return WTLoader(style: .large)
    }()

    private var emailSeparator = WTTextFieldSeparatorView()
    private var passwordSeparator = WTTextFieldSeparatorView()

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white

        addSubviews(
            logoView,
            emailField,
            passwordField,
            loginButton,
            registerButton,
            loader
        )
        setupConstraints()
        setupGenericComponents()

        self.setTextFieldDelegate(
            self, for: [emailField, passwordField]
        )

        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: Layout

extension WTLoginView {
    
    private func setupGenericComponents() {
        addSubviews(emailSeparator, passwordSeparator)
        
        NSLayoutConstraint.activate([
            loader.heightAnchor.constraint(equalToConstant: 100),
            loader.widthAnchor.constraint(equalToConstant: 100),
            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        for (field, separator) in [emailField: emailSeparator, passwordField: passwordSeparator] {
            NSLayoutConstraint.activate([
                separator.widthAnchor.constraint(equalToConstant: 360),
                separator.heightAnchor.constraint(equalToConstant: 0.8),
                separator.centerXAnchor.constraint(equalTo: centerXAnchor),
                separator.bottomAnchor.constraint(equalTo: field.bottomAnchor, constant: -8),
            ])
        }
    }
    
    private func setupConstraints() {
        loginButton.setSize()
        registerButton.setSize()
        logoView.setSize()
        
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: self.topAnchor, constant: 120),
            logoView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            emailField.widthAnchor.constraint(equalToConstant: 360),
            emailField.heightAnchor.constraint(equalToConstant: 65),
            emailField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emailField.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 118),
            
            passwordField.widthAnchor.constraint(equalToConstant: 360),
            passwordField.heightAnchor.constraint(equalToConstant: 65),
            passwordField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 25),
            
            loginButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 125),
            registerButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 18),
        ])
    }
}


// MARK: Button methods
extension WTLoginView {
    
    @objc
    func didTapLogin() {
        if let emailInput = emailField.text,
           let passwordInput = passwordField.text {
            if !emailInput.contains("@") {
                delegate?.didTypeWrongCredentials()
            }
            else {
                self.loader.startLoader()
                delegate?.wTLoginView(self, receivedUserEmail: emailInput,
                                      receivedUserPassword: passwordInput)
            }
        }
        else {
            delegate?.didTypeWrongCredentials()
        }
    }
    
    @objc
    func didTapRegister() {
        delegate?.didSelectRegisterButton()
    }
}

extension WTLoginView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

}
