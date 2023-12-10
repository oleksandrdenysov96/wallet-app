//
//  WTAbstractViewController.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 06.12.2023.
//

import UIKit

class WTAbstractViewController: UIViewController {

        init(loginModel: LoginResponse) {
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            self.setupLogo()
            self.setupNavBar(userLabel: self.loginModel.data.user.name)
        }
    }

    // MARK: Layout base
    extension WTHomePageViewController {

    //    private func setupLogo() {
    //        NSLayoutConstraint.activate([
    //            logoImage.heightAnchor.constraint(equalToConstant: 38),
    //            logoImage.widthAnchor.constraint(equalToConstant: 163),
    //        ])
    //    }

    //    private func setupNavBar() {
    //
    //        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoImage)
    //        navigationItem.setRightBarButtonItems(
    //            [
    //                UIBarButtonItem(
    //                    customView: homePageView.setupLogoutView()
    //                ),
    //                UIBarButtonItem(
    //                    title: self.loginModel.data.user.name,
    //                    style: .plain,
    //                    target: self,
    //                    action: .none
    //                ),
    //            ],
    //            animated: true)
    //        navigationItem.rightBarButtonItems?.last!.tintColor = .black
    //    }

    }


}
