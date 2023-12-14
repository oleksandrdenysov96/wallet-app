//
//  WTRegisterViewViewModel.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 26.11.2023.
//

import Foundation

protocol WTRegisterViewViewModelDelegate: AnyObject {
    func didPerformRegistration(receivedResponse: WTRegisterResponse)
    
    func enteredWrongCreds(errTitle: String, errMessage: String)
    func backToLoginSelected()
}

final class WTRegisterViewViewModel {
    
    public weak var delegate: WTRegisterViewViewModelDelegate?
        
    private var registerResponseModel: WTRegisterResponse?
    
    private func executeRegisterPostRequest(email: String, password: String, username: String,
                                            completion: @escaping (Result<WTRegisterResponse, Error>, Int?) -> Void) {

        let jsonBody: [String: Any] = [
            "name": username,
            "email": email,
            "password": password
        ]
        
        guard let url = URL(string: "\(WTRequest.Constants.baseUrl)/\(WTEndpoint.auth.rawValue)/register"),
              let request = WTRequest(url: url, httpMethod: .post),
              
                let body = WTService.shared.requestBody(body: jsonBody) else {
            return
        }
        
        WTService.shared.executeRequest(request, body: body,
                                            expected: WTRegisterResponse.self, completion: completion)
    }
}

extension WTRegisterViewViewModel: WTRegisterViewDelegate {
    func didTapBackToLogin() {
        delegate?.backToLoginSelected()
    }
    
    func wTRegisterView(_ registerView: WTRegisterView, email emailInput: String,
                        password passwordInput: String, username usernameInput: String) {
        
        self.executeRegisterPostRequest(email: emailInput,
                                        password: passwordInput,
                                        username: usernameInput) { [weak self] result, _ in
            switch result {
            case .success(let model):
                self?.delegate?.didPerformRegistration(receivedResponse: model)
    
            case .failure(_):
                self?.delegate?.enteredWrongCreds(errTitle: "Registration failed",
                                                  errMessage: "Operation couldn't performed")
            }
        }
    }
    
    func didEnterWrongData() {
        delegate?.enteredWrongCreds(errTitle: "Wrong values for register",
                                    errMessage: "Check your data and try again")
    }
    
}
