//
//  WTDropDownListView.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 08.12.2023.
//

import UIKit
import DropDown

class WTDropDownCategoriesListView: UIView {

    private let dropDown: DropDown = {
        let menu =  DropDown()
        return menu
    }()

    private let menuLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select category"
        label.textColor = .gray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()

    public var selectedCategory = "Basic"

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .wtMainBackgroundColor
        addSubview(menuLabel)
        setupConstraint()
        dropDown.anchorView = menuLabel

        let gesture = UITapGestureRecognizer(
            target: self, action: #selector(didTapItem)
        )
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        addGestureRecognizer(gesture)
        setupConstraint()

        dropDown.selectionAction = { [weak self] _, title in
            self?.selectedCategory = title
            self?.menuLabel.text = title
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    @objc
    private func didTapItem() {
        dropDown.show()
    }

    private func setupConstraint() {
        NSLayoutConstraint.activate([
            menuLabel.topAnchor.constraint(equalTo: topAnchor),
            menuLabel.leftAnchor.constraint(equalTo: leftAnchor),
            menuLabel.rightAnchor.constraint(equalTo: rightAnchor),
            menuLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    public func setupListDataSource(source: [String]) {
        menuLabel.text = "Select category"
        dropDown.dataSource = source
    }

}
