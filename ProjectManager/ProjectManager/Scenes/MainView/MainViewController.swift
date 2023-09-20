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
        stackView.spacing = Constant.stackViewSpacing
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
    
    private var disposeBag: DisposeBag = .init()
    private let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
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
        super.viewDidLoad()
        configureNavigationBar()
        configureRootView()
        setupLayoutConstraints()
        bindUI()
    }
    
    private func configureNavigationBar() {
        self.navigationItem.title = Constant.title
        self.navigationItem.rightBarButtonItem = addBarButton
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
    
    private func bindUI() {
        let input = MainViewModel.Input(
            viewWillAppearEvent: self.rx.viewWillAppear.asSingle(),
            addBarButtonTapped: addBarButton.rx.tap.asDriver()
        )
        let output = viewModel.transform(input)
        
        output.projectListViewModels
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, projectListViewModels in
                owner.addChildren(with: projectListViewModels)
            }, onError: { owner, error in
                print(error)
                // Alert 띄우기
            })
            .disposed(by: disposeBag)
        
        output.createProjectViewPresented
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func addChildren(with viewModels: [ProjectListViewModel]) {
        viewModels.forEach {
            self.addChild(ProjectListViewController(viewModel: $0))
        }
        
        self.children.forEach { child in
            stackView.addArrangedSubview(child.view)
        }
    }
}

private extension MainViewController {
    enum Constant {
        static let title = "Project Manager"
        static let toolBarHeight: CGFloat = 50
        static let stackViewSpacing: CGFloat = 10
    }
}

