//
//  WTTransactionView.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 06.12.2023.
//

import UIKit

class WTTransactionView: UIView {
    private let viewModel: WTTransactionViewViewModel

    private var transactionType: TransactionType = .income

    private var plusButtonInitialTransform: CGAffineTransform {
        get {
            return plusButton.transform
        }
        set {}
    }

    private let viewTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add transaction"
        label.textColor = .black
        label.font = .systemFont(ofSize: 34, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    /*
     *
     * MARK: BUTTON & LABELS ELEMENTS
     *
     */

    private let incomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Income"
        label.textColor = .wtActionGreen
        label.font = .systemFont(ofSize: 23, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    private let expenseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Expense"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 23, weight: .regular)
        label.textAlignment = .center
        return label
    }()

    private let plusButton: WTFloatingButton = {
        let button = WTFloatingButton(frame: .zero, cornerRadius: 30)
        button.layer.shadowColor = UIColor.wtActionGreen.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.8
        button.layer.shadowRadius = 15
        return button
    }()

    private let buttonContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .wtMainBackgroundColor
        container.layer.cornerRadius = 21
        container.layer.borderWidth = 0.5
        container.layer.borderColor = UIColor.gray.cgColor
        return container
    }()


    /*
     *
     * MARK: PICKER ELEMENTS
     *
     */

    private let categoriesDropDown: WTDropDownListView = {
        return WTDropDownListView()
    }()


    private let datePicker: WTCustomDateControl = {
        let picker = WTCustomDateControl()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.isHidden = true
        picker.alpha = 0
        return picker
    }()
    private let datePickerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(
            Date().formatted(date: .numeric, time: .omitted), for: []
        )

        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.baseForegroundColor = .clear
        buttonConfiguration.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: -245, bottom: 0, trailing: 0
        )
        button.configuration = buttonConfiguration

        button.setTitleColor(.gray, for: .normal)
        return button
    }()

    /*
     *
     * MARK: FIELDS & BUTTONS
     *
     */

    private let sumTextField: WTTextField = {
        let field = WTTextField()
        field.setSize()
        field.setupTextField(placeholder: "0.00")
        field.returnKeyType = .done
        field.borderStyle = .none
        field.keyboardType = .numberPad
        return field
    }()

    private let commentTextField: WTTextField = {
        let field = WTTextField()
        field.setSize(height: 110)
        field.setupTextField(placeholder: "Comment")
        field.contentVerticalAlignment = .top
        field.returnKeyType = .done
        field.borderStyle = .none
        return field
    }()

    private let addButton: WTButton = {
        let button = WTButton()
        button.setSize()
        button.setupButton(
            title: "ADD",
            color: .wtActionGreen,
            textColor: .white
        )
        return button
    }()

    private let cancelButton: WTButton = {
        let button = WTButton()
        button.setSize()
        button.setupButton(
            title: "CANCEL",
            color: .clear,
            textColor: .wtMainBlue,
            withBorder: true
        )
        return button
    }()

    private let separator1 = WTTextFieldSeparatorView()
    private let separator2 = WTTextFieldSeparatorView()
    private let separator3 = WTTextFieldSeparatorView()
    private let separator4 = WTTextFieldSeparatorView()

    init(frame: CGRect, viewModel: WTTransactionViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .wtMainBackgroundColor

        addSubviews(
            viewTitle, buttonContainer, incomeLabel,
            expenseLabel, categoriesDropDown, datePicker, 
            datePickerButton, sumTextField, commentTextField,
            plusButton, addButton, cancelButton,
            separator1, separator2, separator3, separator4
        )
        setupConstraints()
        setupPickerShowing()

        self.setTextFieldDelegate(
            self, for: [sumTextField, commentTextField]
        )

        let tapGesture = UITapGestureRecognizer(
            target: self, action: #selector(handleTap)
        )
        addGestureRecognizer(tapGesture)
        addButtonsTargets(#selector(didTapPlusButton), for: plusButton)
        addButtonsTargets(#selector(didTapDateButton), for: datePickerButton)
        addButtonsTargets(#selector(didTapCancel), for: cancelButton)
        addButtonsTargets(#selector(didTapAdd), for: addButton)

        setupList()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupList() {
        var listSource: [String] = []

        switch transactionType {
        case .income:
            for category in IncomeCategories.allCases {
                listSource.append(category.rawValue.capitalized)
            }
        case .expense:
            for category in ExpenseCategories.allCases {
                listSource.append(category.rawValue.capitalized)
            }
        }
        categoriesDropDown.setupListDataSource(source: listSource)
    }

    @objc
    private func didTapCancel() {
        viewModel.handleCancelAction()
    }

    @objc
    private func didTapAdd() {
        guard !categoriesDropDown.selectedCategory.isEmpty,
              let date = datePickerButton.titleLabel?.text,
              let sum = Int(sumTextField.text ?? "nil")
        else {
            print("Required fields aren't configured")
            return
        }
        viewModel.postTransactionWith(
            type: transactionType.rawValue,
            category: categoriesDropDown.selectedCategory,
            date: date,
            sum: sum,
            comment: commentTextField.text != nil ? commentTextField.text! : nil
        )
    }
}


// MARK: Plus Button Operations

extension WTTransactionView {

    @objc
    private func didTapPlusButton() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else {return}
            self.changeButtonStyle()
            switch transactionType {
            case .income:
                transactionType = .expense
                setupList()
            case .expense:
                transactionType = .income
                setupList()
            }
        }
    }

    private func changeButtonStyle() {
        switch transactionType {
        case .income:
            plusButton.transform = CGAffineTransform(translationX: 36, y: 0)
            self.plusButton.backgroundColor = .wtActionRed
            self.plusButton.layer.shadowColor = UIColor.wtActionRed.cgColor
            self.plusButton.setTitle("–", for: .normal)
            self.changeLabelsStyle()
        case .expense:
            plusButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.plusButton.backgroundColor = .wtActionGreen
            self.plusButton.layer.shadowColor = UIColor.wtActionGreen.cgColor
            self.plusButton.setTitle("+", for: .normal)
            self.changeLabelsStyle()
        }
    }

    private func changeLabelsStyle() {
        switch transactionType {
        case .income:
            UIView.transition(with: incomeLabel, duration: 0.5, 
                              options: .transitionFlipFromLeft) { [weak self] in
                self?.incomeLabel.font = .systemFont(ofSize: 23, weight: .regular)
                self?.incomeLabel.textColor = .lightGray
            }
            UIView.transition(with: expenseLabel, duration: 0.5,
                              options: .transitionFlipFromLeft) { [weak self] in
                self?.expenseLabel.font = .systemFont(ofSize: 23, weight: .semibold)
                self?.expenseLabel.textColor = .wtActionRed
            }

        case .expense:
            UIView.transition(with: incomeLabel, duration: 0.5, 
                              options: .transitionFlipFromRight) { [weak self] in
                self?.expenseLabel.font = .systemFont(ofSize: 23, weight: .regular)
                self?.expenseLabel.textColor = .lightGray
            }
            UIView.transition(with: expenseLabel, duration: 0.5, 
                              options: .transitionFlipFromRight) { [weak self] in
                self?.incomeLabel.font = .systemFont(ofSize: 23, weight: .semibold)
                self?.incomeLabel.textColor = .wtActionGreen
            }
        }
    }
}


// MARK: Date Picker view operations

extension WTTransactionView {
    
    private func setupPickerShowing() {
        datePicker.dismissClosure = { [weak self] in
            guard let self = self else {
                return
            }
            UIView.animate(withDuration: 0.3, animations: {
                self.datePicker.alpha = 0
            }) { _ in
                self.datePicker.isHidden = true
            }
        }
        datePicker.changeClosure = { [weak self] dateValue in
            guard let self = self else {
                return
            }
            self.datePickerButton.setTitle(
                dateValue.formatted(
                    date: .numeric, time: .omitted
                ),
                for: .normal
            )
        }
    }

    @objc
    private func didTapDateButton()  {
        bringSubviewToFront(datePicker)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.datePicker.isHidden = false
            self?.datePicker.alpha = 1
        }
    }
}


// MARK: CONSTRAINTS

extension WTTransactionView {

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            viewTitle.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            viewTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            viewTitle.heightAnchor.constraint(equalToConstant: 35),

            // MARK: BUTTON
            buttonContainer.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 80),
            buttonContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonContainer.heightAnchor.constraint(equalToConstant: 40),
            buttonContainer.widthAnchor.constraint(equalToConstant: 90),

            plusButton.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor),
            plusButton.leftAnchor.constraint(equalTo: buttonContainer.leftAnchor, constant: -4),
            plusButton.heightAnchor.constraint(equalToConstant: 60),
            plusButton.widthAnchor.constraint(equalToConstant: 60),

            incomeLabel.rightAnchor.constraint(equalTo: buttonContainer.leftAnchor, constant: -45),
            incomeLabel.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor),

            expenseLabel.leftAnchor.constraint(equalTo: buttonContainer.rightAnchor, constant: 45),
            expenseLabel.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor),

            // MARK: PICKERS
            // DATE PICKER OVERLAY
            datePicker.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            datePicker.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            datePicker.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            datePicker.bottomAnchor.constraint(equalTo: bottomAnchor),

            categoriesDropDown.topAnchor.constraint(equalTo: buttonContainer.bottomAnchor, constant: 45),
            categoriesDropDown.centerXAnchor.constraint(equalTo: centerXAnchor),
            categoriesDropDown.widthAnchor.constraint(equalToConstant: 326),
            categoriesDropDown.heightAnchor.constraint(equalToConstant: 50),

            datePickerButton.topAnchor.constraint(equalTo: categoriesDropDown.bottomAnchor, constant: 15),
            datePickerButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            datePickerButton.widthAnchor.constraint(equalToConstant: 325),
            datePickerButton.heightAnchor.constraint(equalToConstant: 55),

            // MARK: FIELDS & BUTTONS
            sumTextField.topAnchor.constraint(equalTo: datePickerButton.bottomAnchor, constant: 10),
            sumTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            commentTextField.topAnchor.constraint(equalTo: sumTextField.bottomAnchor, constant: 20),
            commentTextField.centerXAnchor.constraint(equalTo: centerXAnchor),

            addButton.topAnchor.constraint(equalTo: commentTextField.bottomAnchor, constant: 40),
            addButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            cancelButton.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 10),
            cancelButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        // MARK: SEPARATORS
        for (element, separator) in [
            datePickerButton: separator1,
            sumTextField: separator2,
            commentTextField: separator3,
            categoriesDropDown: separator4
        ] {
            NSLayoutConstraint.activate([
                separator.widthAnchor.constraint(equalToConstant: 360),
                separator.heightAnchor.constraint(equalToConstant: 0.8),
                separator.centerXAnchor.constraint(equalTo: centerXAnchor),
                separator.bottomAnchor.constraint(
                    equalTo: element.bottomAnchor,
                    constant: element == categoriesDropDown ? -1 : -8
                ),
            ])
        }
    }
}

extension WTTransactionView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc 
    private func handleTap() {
        sumTextField.resignFirstResponder()
    }
}
