//
//  WTCustomDateControl.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 08.12.2023.
//

import UIKit

import UIKit

class WTCustomDateControl: UIView {

    public var changeClosure: ((Date)->())?
    public var dismissClosure: (()->())?

    let datePicker: UIDatePicker = {
        let view = UIDatePicker()
        return view
    }()

    let pickerHolderView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    func commonInit() -> Void {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)

        [blurredEffectView, pickerHolderView, datePicker].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        addSubview(blurredEffectView)
        pickerHolderView.addSubview(datePicker)
        addSubview(pickerHolderView)

        NSLayoutConstraint.activate([

            blurredEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurredEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurredEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurredEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),

            pickerHolderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
            pickerHolderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
            pickerHolderView.centerYAnchor.constraint(equalTo: centerYAnchor),

            datePicker.topAnchor.constraint(equalTo: pickerHolderView.topAnchor, constant: 20.0),
            datePicker.leadingAnchor.constraint(equalTo: pickerHolderView.leadingAnchor, constant: 20.0),
            datePicker.trailingAnchor.constraint(equalTo: pickerHolderView.trailingAnchor, constant: -20.0),
            datePicker.bottomAnchor.constraint(equalTo: pickerHolderView.bottomAnchor, constant: -20.0),

        ])

        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
            // use default
        }

        datePicker.addTarget(self, action: #selector(didChangeDate(_:)), for: .valueChanged)

        let t = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        blurredEffectView.addGestureRecognizer(t)
    }

    @objc func tapHandler(_ gesture: UITapGestureRecognizer) -> Void {
        dismissClosure?()
    }

    @objc func didChangeDate(_ sender: UIDatePicker) -> Void {
        changeClosure?(sender.date)
    }

}
