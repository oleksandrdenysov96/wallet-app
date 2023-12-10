//
//  WTHomeViewController.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 26.11.2023.
//

import UIKit

class WTTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = .white
        self.tabBar.layer.cornerRadius = 30
        self.setUpTabs()
        for item in self.tabBar.items! {
            item.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
            if let image = item.image {
                let originalImage = image.withRenderingMode(.alwaysOriginal)
                let grayImage = originalImage
                    .withTintColor(UIColor(red: 0.29, green: 0.34, blue: 0.89, alpha: 1))

                item.image = originalImage
                item.selectedImage = grayImage
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
     
    }

    private func setUpTabs() {
        let homePageVC = WTHomePageViewController()
        let statisticsVC = WTStatisticsViewController()
        let exchangeRateVC = WTExchangeRateViewController()
        
        for controller in [homePageVC, statisticsVC, exchangeRateVC] {
            controller.navigationItem.largeTitleDisplayMode = .never
        }
        
        let navigationControllers = [
            UINavigationController(rootViewController: homePageVC),
            UINavigationController(rootViewController: statisticsVC),
            UINavigationController(rootViewController: exchangeRateVC),
        ]
        
        navigationControllers[0].tabBarItem = UITabBarItem(
            title: nil, image: UIImage(named: "home"), tag: 1)

        navigationControllers[1].tabBarItem = UITabBarItem(
            title: nil, image: UIImage(named: "statistics"), tag: 2)
        
        navigationControllers[2].tabBarItem = UITabBarItem(
            title: nil, image: UIImage(named: "exchange"), tag: 3)
        

        self.setViewControllers(navigationControllers, animated: true)
    }
}
