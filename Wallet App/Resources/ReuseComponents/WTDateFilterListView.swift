//
//  WTDateFilterListView.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 12.12.2023.
//

import UIKit
import DropDown

class WTDateFilterListViewButton: UIView {
    
    private let buttonTitle: String

    private let dropDown: DropDown = {
        let menu =  DropDown()
        return menu
    }()

    private let filterButton: WTFilterDateButton = {
        let button = WTFilterDateButton()
        button.setSize()
        return button
    }()

    public var selectedDate = Date().formatted(date: .numeric, time: .omitted)

    init(frame: CGRect, buttonTitle: String) {
        self.buttonTitle = buttonTitle
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .wtMainBackgroundColor
        addSubview(filterButton)
        filterButton.setupButton(title: buttonTitle)
        setupConstraint()
        dropDown.anchorView = self
        filterButton.addTarget(self, action: #selector(didTapItem), for: .touchUpInside)

//        let gesture = UITapGestureRecognizer(
//            target: filterButton, action: #selector(didTapItem)
//        )
//        gesture.numberOfTapsRequired = 1
//        gesture.numberOfTouchesRequired = 1
//        addGestureRecognizer(gesture)

        dropDown.selectionAction = { [weak self] _, title in
            self?.selectedDate = title
            self?.filterButton.setTitle(title, for: .normal)
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
            filterButton.topAnchor.constraint(equalTo: topAnchor),
            filterButton.leftAnchor.constraint(equalTo: leftAnchor),
            filterButton.rightAnchor.constraint(equalTo: rightAnchor),
            filterButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    public func setupListDataSource(source: [String]) {
        filterButton.setTitle(self.buttonTitle, for: .normal)
        dropDown.dataSource = source
    }

}
