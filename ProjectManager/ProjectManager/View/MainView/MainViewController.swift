//
//  MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.backgroundColor = .systemGray4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let addBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: nil,
            action: nil
        )
        
        return barButtonItem
    }()
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureRootView()
        setupLayoutConstraints()
        bindAction()
    }
    
    private func configureNavigationBar() {
        self.navigationItem.title = Constant.title
        self.navigationItem.rightBarButtonItem = self.addBarButton
    }
    
    private func configureRootView() {
        self.view.backgroundColor = .systemGray6
        self.view.addSubview(stackView)
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                                              constant: -Constant.toolBarHeight)
        ])
    }
    
    private func bindAction() {
        addBarButton.rx.tap
            .asObservable()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                let editViewModel = EditViewModel(from: nil)
                let editViewController = EditViewController(viewModel: editViewModel)
                let navigationController = UINavigationController(rootViewController: editViewController)
                navigationController.modalPresentationStyle = .formSheet
                owner.present(navigationController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

private extension MainViewController {
    enum Constant {
        static let title = "Project Manager"
        static let toolBarHeight: CGFloat = 50
    }
}

