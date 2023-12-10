//
//  UIViewControllerExtension.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 06.12.2023.
//

import Foundation
import UIKit


extension UIViewController {

    public func setupLogo() {
        let logoImage = WTLogoView(frame: .zero)
        NSLayoutConstraint.activate([
            logoImage.heightAnchor.constraint(equalToConstant: 38),
            logoImage.widthAnchor.constraint(equalToConstant: 163),
        ])
    }

    public func setupNavBar() {
        let logoImage = WTLogoView(frame: .zero)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoImage)
        navigationItem.setRightBarButtonItems(
            [
                UIBarButtonItem(
                    customView: setupLogoutView()
                ),
                UIBarButtonItem(
                    title: LocalState.userName ?? "undefined",
                    style: .plain,
                    target: self,
                    action: .none
                ),
            ],
            animated: true)
        navigationItem.rightBarButtonItems?.last!.tintColor = .black
    }

    private func setupLogoutView() -> UIView {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "logout")

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 25),
            view.heightAnchor.constraint(equalToConstant: 25),
        ])
        return view
    }
}
// self.loginModel.data.user.name
