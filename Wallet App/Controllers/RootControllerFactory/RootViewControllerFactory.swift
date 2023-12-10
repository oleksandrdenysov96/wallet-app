//
//  RootViewControllerFactory.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 26.11.2023.
//

import UIKit

class RootViewControllerFactory {

    private let loginViewController: WTLoginViewController
    private var homeViewController: WTTabBarController?
    
    init() {
        self.loginViewController = WTLoginViewController()
        self.loginViewController.delegate = self
    }
    
    public var rootViewController: UIViewController {
        if shouldDisplayHomePageScreen() {
            return generateHomeScreen()
        }
        else {
            return generateLoginScreen()
        }
    }
    
    private func shouldDisplayHomePageScreen() -> Bool {
        return LocalState.hasLoggedIn
    }
    
    public func generateLoginScreen() -> UINavigationController {
        return UINavigationController(rootViewController: loginViewController)
    }
    
    public func generateHomeScreen() -> UITabBarController {
        homeViewController = WTTabBarController()
        return homeViewController!
    }
    
    public func makeHomeScreenMainAfterLogin() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = generateHomeScreen()
            window.makeKeyAndVisible()
        }
    }
}

extension RootViewControllerFactory: WTLoginViewControllerDelegate {
    func didLoggedIntoSystem(with model: WTLoginResponse) {
        LocalState.hasLoggedIn = true
        LocalState.loginData = model
    }
    
    
}
