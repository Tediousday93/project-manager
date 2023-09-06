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
        stackView.spacing = Constant.stackViewSpacing
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
    
    private let viewModel: AbstractEditViewModel
    private var disposeBag: DisposeBag = .init()
    
    init(viewModel: AbstractEditViewModel) {
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
//        leftBarButton.title = viewModel.leftBarButtonTitle
//        self.navigationItem.title = (viewModel.sourceProject?.state ?? .todo).rawValue
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.leftBarButtonItem = leftBarButton
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
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                                           constant: Constant.edgeSpacing),
            stackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                                              constant: -Constant.edgeSpacing),
            stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
                                               constant: Constant.edgeSpacing),
            stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
                                                constant: -Constant.edgeSpacing)
        ])
    }
    
    private func bindUI() {
        let viewWillAppearEvent = self.rx.viewWillAppear
            .asObservable()
        
        let titleText = titleTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
        
        let pickedDate = datePicker.rx.date
            .distinctUntilChanged()
        
        let bodyText = bodyTextView.rx.text
            .orEmpty
            .distinctUntilChanged()
        
        let projectContents = Observable.combineLatest(titleText, pickedDate, bodyText)
            .catchAndReturn(("", Date(), ""))
            .map { title, date, body in
                EditViewModel.InputContents(title: title,
                                            date: date,
                                            body: body)
            }
            .asObservable()
        
        let rightBarButtonTapped = rightBarButton.rx.tap
            .asDriver(onErrorJustReturn: ())
            .asObservable()
        
        let input = CreateProjectViewModel.Input(
            viewWillAppearEvent: viewWillAppearEvent,
            rightBarButtonTapped: rightBarButtonTapped,
            projectContents: projectContents
        )
        
        let output = viewModel.transform(input)
        
        output.projectDelegated
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.isContentEdited
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, isContentEdited in
                if isContentEdited {
                    owner.rightBarButton.isEnabled = true
                } else {
                    owner.rightBarButton.isEnabled = false
                }
            }
            .disposed(by: disposeBag)
        
        leftBarButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

private extension EditViewController {
    enum Constant {
        static let titlePlaceholder: String = "Title"
        static let rightBarButtonTitle: String = "Done"
        static let edgeSpacing: CGFloat = 10
        static let stackViewSpacing: CGFloat = 15
    }
}
