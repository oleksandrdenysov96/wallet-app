//
//  WTLoginViewViewModel.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 25.11.2023.
//

import Foundation


protocol WTLoginViewViewModelDelegate: AnyObject {
    func didPerformLogin(receivedResponse: WTLoginResponse)
        
    func enteredWrongCreds(errTitle: String, errMessage: String)
    
    func registrationStarted()
}

final class WTLoginViewViewModel {
    
    public weak var delegate: WTLoginViewViewModelDelegate?
        
    private var loggingResponseModel: WTLoginResponse? 
    
    private var userEmail: String? {
        didSet {
//            UserDefaults.standard.set(userEmail, forKey: "email")
        }
    }
    
    private var userPassword: String? {
        didSet {
//            UserDefaults.standard.set(userPassword, forKey: "password")
        }
    }

    private func executeLogInPostRequest(email: String, password: String, 
                                         completion: @escaping (Result<WTLoginResponse, Error>, Int?) -> Void) {

        self.userEmail = email
        self.userPassword = password
        
        let jsonBody: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        guard let url = URL(string: "\(WTRequest.Constants.baseUrl)/\(WTEndpoint.auth.rawValue)/login"),
              let request = WTRequest(url: url, httpMethod: .post),
              let body = WTService.shared.requestBody(body: jsonBody) else {
            return
        }
        WTService.shared.executeRequest(request, body: body,
                                            expected: WTLoginResponse.self, completion: completion)
    }
}


extension WTLoginViewViewModel: WTLoginViewDelegate {
    func didSelectRegisterButton() {
        delegate?.registrationStarted()
    }
    

    func didTypeWrongCredentials() {
        delegate?.enteredWrongCreds(errTitle: "Wrong credentials",
                                    errMessage: "Check your credentials and try again")
    }
    
    func wTLoginView(_ loginView: WTLoginView, receivedUserEmail email: String, receivedUserPassword password: String) {
        
        self.executeLogInPostRequest(email: email, password: password) { [weak self] result, _ in
            switch result {
            case .success(let model):
//                self?.loggingResponseModel = model
                self?.delegate?.didPerformLogin(receivedResponse: model)
            case .failure(_):
                self?.delegate?.enteredWrongCreds(errTitle: "Log in failed",
                                                  errMessage: "Operation couldn't performed")
            }
        }
    }
}
