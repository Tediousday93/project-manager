//
//  ProjectListViewModel.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/13.
//

import Foundation
import RxSwift
import RxCocoa

final class ProjectListViewModel {
    let updateTrigger: BehaviorRelay<Void> = .init(value: ())
    let projectList: BehaviorRelay<[Project]> = .init(value: [])
    let projectState: Project.State
    
    private let useCase: ProjectListUseCaseType
    private let navigator: MainNavigator
    
    init(useCase: ProjectListUseCaseType,
         navigator: MainNavigator,
         projectState: Project.State) {
        self.useCase = useCase
        self.navigator = navigator
        self.projectState = projectState
    }
}

extension ProjectListViewModel: ViewModelType {
    struct Input {
        let itemSelected: Driver<IndexPath>
        let itemDeleted: Driver<IndexPath>
    }
    
    struct Output {
        let projectListFetched: Driver<Void>
        let updateProjectViewPresented: Driver<Void>
        let deleteProject: Observable<IndexPath?>
    }
    
    func transform(_ input: Input) -> Output {
        let projectListFetched = updateTrigger
            .flatMap { [unowned self] _ in
                useCase.projectList(forState: projectState)
            }
            .withUnretained(self)
            .map { owner, projectList in
                owner.projectList.accept(projectList)
            }
            .asDriver(onErrorJustReturn: ())
        
        let updateProjectViewPresented = input.itemSelected
            .map { [unowned self] indexPath in
                return projectList.value[indexPath.row]
            }
            .map { [unowned self] project in
                navigator.toUpdate(project, delegate: self)
            }
        
        let deleteProject = input.itemDeleted
            .asObservable()
            .withUnretained(self)
            .map { owner, indexPath in
                let project = owner.projectList.value[indexPath.row]
                try owner.useCase.delete(project: project)
                
                return Optional(indexPath)
            }
        
        return Output(projectListFetched: projectListFetched,
                      updateProjectViewPresented: updateProjectViewPresented,
                      deleteProject: deleteProject)
    }
}

extension ProjectListViewModel: EditViewModelDelegate { }
