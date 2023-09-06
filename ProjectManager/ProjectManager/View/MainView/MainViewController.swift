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
    
    private func bindUI() {
        let viewWillAppearEvent = self.rx.viewWillAppear
            .asObservable()
        let addBarButtonTapped = addBarButton.rx.tap
            .asObservable()
        
        let input = MainViewModel.Input(
            viewWillAppearEvent: viewWillAppearEvent,
            addBarButtonTapped: addBarButtonTapped
        )
        let output = viewModel.transform(input)
        
        output.projectListViewModels
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, projectListViewModels in
                owner.addChildren(with: projectListViewModels)
            }, onError: { error in
                print(error)
                // Alert 띄우기
            })
            .disposed(by: disposeBag)
        
        output.editViewModel
            .drive(with: self) { owner, editViewModel in
                owner.presentEditView(viewModel: editViewModel)
            }
            .disposed(by: disposeBag)
    }
    
    private func addChildren(with viewModels: [ProjectListViewModel]) {
        viewModels.forEach { [weak self] in
            guard let self else { return }
            
            self.addChild(ProjectListViewController(viewModel: $0))
        }
        
        self.children.forEach { child in
            stackView.addArrangedSubview(child.view)
        }
    }
    
    private func presentEditView(viewModel: CreateProjectViewModel) {
        let editViewController = EditViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: editViewController)
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .systemGray6
        
        navigationController.navigationBar.scrollEdgeAppearance = barAppearance
        navigationController.modalPresentationStyle = .formSheet
        
        self.present(navigationController, animated: true)
    }
}

private extension MainViewController {
    enum Constant {
        static let title = "Project Manager"
        static let toolBarHeight: CGFloat = 50
        static let stackViewSpacing: CGFloat = 10
    }
}

