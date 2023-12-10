//
//  UIVIewExtension.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 16.11.2023.
//

import Foundation
import UIKit

extension UIView {
    
    func addSubviews(_ viewsList: UIView...) {
        for view in viewsList {
            addSubview(view)
        }
    }
    
    func setTextFieldDelegate<T: UITextFieldDelegate>(_ view: T, for fields: [WTTextField]) {
        fields.forEach { $0.delegate = view }
    }

    func addButtonsTargets(_ action: Selector, for button: UIButton) {
        button.addTarget(self, action: action, for: .touchUpInside)
    }
}

extension UIColor {

    public static var wtMainBackgroundColor: UIColor {
        return UIColor(
            red: 238/255, green: 238/255, blue: 238/255, alpha: 1
        )
    }

    public static var wtActionGreen: UIColor {
        return UIColor(
            red: 0.14, green: 0.8, blue: 0.65, alpha: 1
        )
    }

    public static var wtActionRed: UIColor {
        return UIColor(
            red: 1, green: 0.4, blue: 0.59, alpha: 1
        )
    }

    public static var wtMainBlue: UIColor {
        return UIColor(
            red: 0.29, green: 0.34, blue: 0.89, alpha: 1
        )
    }

    
}
