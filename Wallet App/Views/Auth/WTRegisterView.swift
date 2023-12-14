//
//  WTRegisterView.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 26.11.2023.
//

import UIKit

protocol WTRegisterViewDelegate: AnyObject {
    func wTRegisterView(_ registerView: WTRegisterView, email emailInput: String,
                        password passwordInput: String, username usernameInput: String)
    
    func didEnterWrongData()
    func didTapBackToLogin()
}

class WTRegisterView: UIView {
    
    public weak var delegate: WTRegisterViewDelegate?
    
    private let logoView: WTLogoView = {
        return WTLogoView(frame: .zero)
    }()
    
    private let emailField: WTTextField = {
        let textField = WTTextField()
        textField.setupTextField(placeholder: "   Email")
        return textField
    }()
    
    private let passwordField: WTTextField = {
        let textField = WTTextField()
        textField.setupTextField(placeholder: "   Password", isSecureField: true)
        return textField
    }()
    
    private let confirmPasswordField: WTTextField = {
        let textField = WTTextField()
        textField.setupTextField(placeholder: "   Confirm password", isSecureField: true)
        return textField
    }()
    
    private let nameField: WTTextField = {
        let textField = WTTextField()
        textField.setupTextField(placeholder: "   First name")
        return textField
    }()
    
    private let registerButton: WTButton = {
        let button = WTButton()
        button.customText = "REGISTER"
        button.customBackgroundColor = UIColor(
            red: 0.141, green: 0.8, blue: 0.655, alpha: 1
        )
        button.customTextColor = .white
        return button
    }()
    
    private let loginButton: WTButton = {
        let button = WTButton()
        button.customText = "LOGIN"
        button.customTextColor = UIColor(red: 0.29, green: 0.337, blue: 0.886, alpha: 1)
        button.customBackgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.borderColor = UIColor(
            red: 0.29,
            green: 0.337,
            blue: 0.886,
            alpha: 1
        ).cgColor
        
        button.layer.borderWidth = 1.3
        return button
    }()
    
    private var emailSeparator = WTTextFieldSeparatorView()
    private var passwordSeparator = WTTextFieldSeparatorView()
    private var confirmPasswordSeparator = WTTextFieldSeparatorView()
    private var nameSeparator = WTTextFieldSeparatorView()
    public var loader = WTLoader(style: .large)


    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        
        addSubviews(
            logoView,
            emailField,
            passwordField,
            confirmPasswordField,
            nameField,
            registerButton,
            loginButton
        )
        setupConstraints()
        setupGenericComponents()

        self.setTextFieldDelegate(
            self, for: [nameField, emailField, passwordField, confirmPasswordField]
        )

        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(didTapBackToLogin), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: Layout
extension WTRegisterView {
    private func setupGenericComponents() {
        addSubviews(emailSeparator, passwordSeparator,
                    confirmPasswordSeparator, nameSeparator, loader)

        for (element, separator) in [
            emailField: emailSeparator,
            passwordField: passwordSeparator,
            confirmPasswordField: confirmPasswordSeparator
        ] {
            NSLayoutConstraint.activate([
                separator.widthAnchor.constraint(equalToConstant: 360),
                separator.heightAnchor.constraint(equalToConstant: 0.8),
                separator.centerXAnchor.constraint(equalTo: centerXAnchor),
                separator.bottomAnchor.constraint(equalTo: element.bottomAnchor, constant: -8),
            ])
        }

        NSLayoutConstraint.activate([
            loader.heightAnchor.constraint(equalToConstant: 100),
            loader.widthAnchor.constraint(equalToConstant: 100),
            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    
    private func setupConstraints() {
        loginButton.setSize()
        registerButton.setSize()
        logoView.setSize()
        
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: self.topAnchor, constant: 45),
            logoView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            emailField.widthAnchor.constraint(equalToConstant: 360),
            emailField.heightAnchor.constraint(equalToConstant: 65),
            emailField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emailField.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 70),
            
            passwordField.widthAnchor.constraint(equalToConstant: 360),
            passwordField.heightAnchor.constraint(equalToConstant: 65),
            passwordField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 25),
            
            confirmPasswordField.widthAnchor.constraint(equalToConstant: 360),
            confirmPasswordField.heightAnchor.constraint(equalToConstant: 65),
            confirmPasswordField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            confirmPasswordField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 25),
            
            nameField.widthAnchor.constraint(equalToConstant: 360),
            nameField.heightAnchor.constraint(equalToConstant: 65),
            nameField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nameField.topAnchor.constraint(equalTo: confirmPasswordField.bottomAnchor, constant: 25),
            
            loginButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 100),
            registerButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 18),
        ])
    }
}

extension WTRegisterView {
    
    @objc
    private func didTapRegister() {
        
        if let emailInput = emailField.text,
           let passwordInput = passwordField.text,
           let confirmPasswordInput = confirmPasswordField.text,
           let nameInput = nameField.text,
           emailInput.contains("@"),
           emailInput.count > 3,
           !passwordInput.isEmpty && passwordInput.count > 6,
           passwordInput.elementsEqual(confirmPasswordInput),
           !nameInput.isEmpty && !nameInput.contains(" ") && nameInput.count > 4 {
            
            self.loader.startLoader()
            delegate?.wTRegisterView(
                self,
                email: emailInput,
                password: passwordInput,
                username: nameInput
            )
        }
        else {
            delegate?.didEnterWrongData()
        }
    }
    
    @objc
    private func didTapBackToLogin() {
        delegate?.didTapBackToLogin()
    }
}

extension WTRegisterView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
}
