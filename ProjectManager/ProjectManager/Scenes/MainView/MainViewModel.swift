//
//  MainViewModel.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/12.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel {
    private var children: [ProjectListViewModel] = []
    private let navigator: MainNavigator
    private let coreDataUseCase: ProjectListUseCaseType
    
    init(navigator: MainNavigator,
         coreDataUseCase: ProjectListUseCaseType) {
        self.navigator = navigator
        self.coreDataUseCase = coreDataUseCase
    }
}

extension MainViewModel: ViewModelType {
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let addBarButtonTapped: Driver<Void>
    }
    
    struct Output {
        let projectListViewModels: Observable<[ProjectListViewModel]>
        let createProjectViewPresented: Driver<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let projectListViewModels = input.viewWillAppearEvent
            .withUnretained(self)
            .map { owner, _ in
                let viewModels = Project.State
                    .allCases
                    .map { state in
                        ProjectListViewModel(useCase: owner.coreDataUseCase,
                                             navigator: owner.navigator,
                                             projectState: state)
                    }
                
                viewModels.forEach { $0.parent = owner }
                owner.children = viewModels
                
                return viewModels
            }
        
        let createProjectViewPresented = input.addBarButtonTapped
            .asObservable()
            .compactMap { [weak self] _ in
                self?.children.first(where: { $0.projectState == .todo })
            }
            .withUnretained(self)
            .map { owner, todoViewModel in
                owner.navigator.toCreateProject(updateTrigger: todoViewModel.updateTrigger)
            }
            .asDriver(onErrorJustReturn: ())
        
        return Output(projectListViewModels: projectListViewModels,
                      createProjectViewPresented: createProjectViewPresented)
    }
}

extension MainViewModel: ChangeStateViewModelDelegate {
    func updateListView(states: [Project.State]) {
        states.forEach { state in
            switch state {
            case .todo:
                children[safe: 0]?.updateTrigger.accept(())
            case .doing:
                children[safe: 1]?.updateTrigger.accept(())
            case .done:
                children[safe: 2]?.updateTrigger.accept(())
            }
        }
    }
}
