//
//  EditProjectViewController.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/17.
//

import UIKit
import RxSwift
import RxCocoa

final class EditProjectViewController<ViewModelType: AbstractEditViewModel>: UIViewController {
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = .preferredFont(forTextStyle: .title3)
        textField.textColor = .black
        textField.placeholder = Constant().titlePlaceholder
        
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
        stackView.spacing = Constant().stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private var rightBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: Constant().rightBarButtonTitle,
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
    
    private let viewModel: ViewModelType
    private var disposeBag: DisposeBag = .init()
    
    init(viewModel: ViewModelType) {
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
        bindUI()
    }
    
    private func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        leftBarButton.title = viewModel.leftBarButtonTitle
    }
    
    private func configureRootView() {
        self.view.backgroundColor = .systemBackground
    }
    
    private func configureViewHierarchy() {
        self.view.addSubview(stackView)
        
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(datePicker)
        stackView.addArrangedSubview(bodyTextView)
    }
    
    private func setupLayoutConstraints() {
        let constant = Constant()
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                                           constant: constant.edgeSpacing),
            stackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                                              constant: -constant.edgeSpacing),
            stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
                                               constant: constant.edgeSpacing),
            stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
                                                constant: -constant.edgeSpacing)
        ])
    }
    
    private func bindUI() {
        let input = CreateProjectViewModel.Input(
            title: titleTextField.rx.text.orEmpty.asDriver(),
            date: datePicker.rx.date.distinctUntilChanged().asDriver(onErrorJustReturn: Date()),
            body: bodyTextView.rx.text.orEmpty.asDriver(),
            rightBarButtonTapped: rightBarButton.rx.tap.asDriver(),
            leftBarButtonTapped: leftBarButton.rx.tap.asDriver()
        )
        let output = viewModel.transform(input)
        
        output.canSave
            .drive(with: self) { owner, canSave in
                owner.rightBarButton.isEnabled = canSave
            }
            .disposed(by: disposeBag)
        
        output.projectSave
            .subscribe(onError: { error in
                print(error)
                // Alert 띄우기
            })
            .disposed(by: disposeBag)
        
        output.canEdit
            .drive(with: self) { owner, canEdit in
                owner.titleTextField.isEnabled = canEdit
                owner.datePicker.isEnabled = canEdit
                owner.bodyTextView.isUserInteractionEnabled = canEdit
            }
            .disposed(by: disposeBag)
        
        output.dismiss
            .drive()
            .disposed(by: disposeBag)
    }
}

private extension EditProjectViewController {
    struct Constant {
        let titlePlaceholder: String = "Title"
        let rightBarButtonTitle: String = "Done"
        let edgeSpacing: CGFloat = 10
        let stackViewSpacing: CGFloat = 15
    }
}
