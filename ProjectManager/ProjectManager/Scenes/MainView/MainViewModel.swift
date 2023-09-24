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
            .map { [unowned self] _ in
                let todoListViewModel = ProjectListViewModel(useCase: coreDataUseCase,
                                                             navigator: navigator,
                                                             projectState: .todo)
                let doingListViewModel = ProjectListViewModel(useCase: coreDataUseCase,
                                                              navigator: navigator,
                                                              projectState: .doing)
                let doneListViewModel = ProjectListViewModel(useCase: coreDataUseCase,
                                                             navigator: navigator,
                                                             projectState: .done)
                let viewModels = [todoListViewModel, doingListViewModel, doneListViewModel]
                
                self.children = viewModels
                
                return viewModels
            }
            .asObservable()
        
        let createProjectViewPresented = input.addBarButtonTapped
            .map { [unowned self] _ in
                let todoViewModel = children.first(where: { $0.projectState == .todo })
                navigator.toCreateProject(delegate: todoViewModel)
            }
        
        return Output(projectListViewModels: projectListViewModels,
                      createProjectViewPresented: createProjectViewPresented)
    }
}
