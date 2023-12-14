//
//  WTFilterDateButton.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 11.12.2023.
//

import UIKit

class WTFilterDateButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        setupDefaults()
        setupChevron()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDefaults() {
        titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        contentHorizontalAlignment = .left
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        titleLabel?.frame.size.width = 150
        layer.cornerRadius = 30
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
    }

    public func setupButton(title: String) {
        setTitle(title, for: .normal)
        setTitleColor(.black, for: .normal)
    }

    public func setSize(width: CGFloat = 360, height: CGFloat = 60) {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: height),
        ])
    }

    private func setupChevron() {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.down"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        imageView.tintColor = .black
        self.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -30),


        ])
    }
}
