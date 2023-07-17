//
//  EditProjectViewController.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/17.
//

import UIKit

final class EditProjectViewController: UIViewController {
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = .preferredFont(forTextStyle: .title3)
        textField.textColor = .black
        textField.placeholder = Constant.titlePlaceholder
        
        return textField
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        
        return datePicker
    }()
    
    let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        
        return textView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureViewHierarchy()
        setupLayoutConstraints()
    }
    
    private func configureViewHierarchy() {
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(datePicker)
        stackView.addArrangedSubview(bodyTextView)
        
        view.addSubview(stackView)
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                           constant: Constant.spacing),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                              constant: -Constant.spacing),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                               constant: Constant.spacing),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                constant: -Constant.spacing)
        ])
    }
    
    private enum Constant {
        static let titlePlaceholder: String = "Title"
        static let spacing: CGFloat = 10
    }
}
