//
//  EditProjectViewController.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/17.
//

import UIKit
import RxSwift
import RxCocoa

final class EditProjectViewController: UIViewController {
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = .preferredFont(forTextStyle: .title3)
        textField.textColor = .black
        textField.placeholder = Constant.titlePlaceholder
        
        return textField
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        
        return datePicker
    }()
    
    private let bodyTextView: UITextView = {
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
    
    private var rightBarButton: UIBarButtonItem?
    private var leftBarButton: UIBarButtonItem?
    
    private let viewModel: EditProjectViewModel
    
    init(viewModel: EditProjectViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureViewHierarchy()
        setupLayoutConstraints()
    }
    
    private func configureNavigationBar() {
        self.rightBarButton = UIBarButtonItem(
            title: Constant.rightBarButtonTitle,
            style: .plain,
            target: nil,
            action: nil
        )
        rightBarButton?.isEnabled = false
        
        self.leftBarButton = UIBarButtonItem(
            title: viewModel.mode.leftBarButtonTitle,
            style: .plain,
            target: nil,
            action: nil
        )
        
        self.navigationItem.title = Constant.navigationBarTitle
        self.navigationItem.rightBarButtonItem = self.rightBarButton
        self.navigationItem.leftBarButtonItem = self.leftBarButton
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
        static let navigationBarTitle: String = "TODO"
        static let rightBarButtonTitle: String = "Done"
        static let spacing: CGFloat = 10
    }
}
