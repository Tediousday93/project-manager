//
//  ChangeStateViewController.swift
//  ProjectManager
//
//  Created by Rowan on 2023/09/26.
//

import UIKit
import RxSwift
import RxCocoa

final class ChangeStateViewController: UIViewController {
    private let firstButton: MoveToButton = .init()
    private let secondButton: MoveToButton = .init()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 10
        
        return stackView
    }()
    
    private let viewModel: ChangeStateViewModel
    private var disposeBag: DisposeBag = .init()
    
    init(viewModel: ChangeStateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        disposeBag = .init()
    }
    
    override func viewDidLoad() {
        configureRootView()
        setupViewHierarchy()
        setupLayoutConstraints()
        setupBindings()
    }
    
    private func configureRootView() {
        self.view.backgroundColor = .systemGray6
    }
    
    private func setupViewHierarchy() {
        stackView.addArrangedSubview(firstButton)
        stackView.addArrangedSubview(secondButton)
        
        self.view.addSubview(stackView)
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupBindings() {
        let firstButtonTapped = firstButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                owner.firstButton.titleSuffix
            }
        let secondButtonTapped = secondButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                owner.secondButton.titleSuffix
            }
        
        let input = ChangeStateViewModel.Input(
            viewWillAppearEvent: self.rx.viewWillAppear.asObservable(),
            firstButtonTapped: firstButtonTapped,
            secondButtonTapped: secondButtonTapped
        )
        let output = viewModel.transform(input)
        
        output.buttonTitles
            .drive(with: self) { owner, buttonTitles in
                owner.firstButton.setTitle(buttonTitles[safe: 0], for: .normal)
                owner.secondButton.setTitle(buttonTitles[safe: 1], for: .normal)
            }
            .disposed(by: disposeBag)
        
        output.stateChanged
            .catch { error in
                // 얼럿 띄우기
                print(error)
                return Observable.just(())
            }
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
