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
        let addBarButtonTapped: Observable<Void>
    }
    
    struct Output {
        let projectListViewModels: Observable<[ProjectListViewModel]>
        let createProjectViewPresented: Driver<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let projectListViewModels = input.viewWillAppearEvent
            .withUnretained(self)
            .map { owner, _ in
                let todoListViewModel = ProjectListViewModel(useCase: owner.coreDataUseCase)
                let doingListViewModel = ProjectListViewModel(useCase: owner.coreDataUseCase)
                let doneListViewModel = ProjectListViewModel(useCase: owner.coreDataUseCase)
                let viewModels = [todoListViewModel, doingListViewModel, doneListViewModel]
                
                owner.addChildren(viewModels)
                
                return viewModels
            }
        let createProjectViewPresented = input.addBarButtonTapped
            .do(onNext: navigator.toCreateProject)
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            projectListViewModels: projectListViewModels,
            createProjectViewPresented: createProjectViewPresented
        )
    }
    
    private func addChildren(_ children: [ProjectListViewModel]) {
        children.forEach { [weak self] child in
            guard let self else { return }
            
            self.children.append(child)
        }
    }
}
