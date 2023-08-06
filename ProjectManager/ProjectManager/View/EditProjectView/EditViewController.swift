//
//  EditViewController.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/17.
//

import UIKit
import RxSwift
import RxCocoa

final class EditViewController: UIViewController {
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
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private var rightBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: Constant.rightBarButtonTitle,
                                            style: .plain,
                                            target: nil,
                                            action: nil)
        barButtonItem.isEnabled = false
        
        return barButtonItem
    }()
    
    private var leftBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: nil,
                                            style: .plain,
                                            target: nil,
                                            action: nil)
        return barButtonItem
    }()
    
    private let viewModel: EditViewModel
    private var disposeBag: DisposeBag = .init()
    
    init(viewModel: EditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        disposeBag = .init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureRootView()
        configureViewHierarchy()
        setupLayoutConstraints()
        bindAction()
    }
    
    private func configureNavigationBar() {
        self.leftBarButton.title = viewModel.mode.leftBarButtonTitle
        self.navigationItem.title = Constant.navigationBarTitle
        self.navigationItem.rightBarButtonItem = self.rightBarButton
        self.navigationItem.leftBarButtonItem = self.leftBarButton
    }
    
    private func configureRootView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureViewHierarchy() {
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(datePicker)
        stackView.addArrangedSubview(bodyTextView)
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                           constant: Constant.edgeSpacing),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                              constant: -Constant.edgeSpacing),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                               constant: Constant.edgeSpacing),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                constant: -Constant.edgeSpacing)
        ])
    }
    
    private func bindAction() {
        let rightBarButtonTapped = rightBarButton.rx
            .tap
            .asObservable()
        
        let input = EditViewModel.Input(rightBarButtonTapped: rightBarButtonTapped)
        let output = viewModel.transform(input: input)
        
        output.projectCreated
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        leftBarButton.rx
            .tap
            .asObservable()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

private extension EditViewController {
    enum Constant {
        static let titlePlaceholder: String = "Title"
        static let navigationBarTitle: String = "TODO"
        static let rightBarButtonTitle: String = "Done"
        static let edgeSpacing: CGFloat = 10
    }
}
