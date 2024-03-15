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
    let projectList: BehaviorRelay<[Project]> = .init(value: [])
    let updateTrigger: PublishRelay<Void> = .init()
    let projectState: Project.State
    
    weak var parent: MainViewModel?
    
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
        let longPressEnded: Driver<IndexPath?>
    }
    
    struct Output {
        let projectListFetched: Driver<Void>
        let updateProjectViewPresented: Driver<Void>
        let deleteProject: Observable<IndexPath?>
        let longPressedCellSource: Observable<ChangeStateViewModel>
    }
    
    func transform(_ input: Input) -> Output {
        let projectListFetched = updateTrigger
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.useCase.projectList(forState: owner.projectState)
                    .map { (owner, $0) }
            }
            .map { owner, projectList in
                owner.projectList.accept(projectList)
            }
            .asDriver(onErrorJustReturn: ())
        
        let updateProjectViewPresented = input.itemSelected
            .asObservable()
            .withUnretained(self)
            .map { owner, indexPath in
                (owner, owner.projectList.value[indexPath.row])
            }
            .map { owner, project in
                owner.navigator.toUpdateProject(
                    project,
                    updateTrigger: owner.updateTrigger
                )
            }
            .asDriver(onErrorJustReturn: ())
        
        let deleteProject = input.itemDeleted
            .asObservable()
            .withUnretained(self)
            .map { owner, indexPath in
                let project = owner.projectList.value[indexPath.row]
                try owner.useCase.delete(project: project)
                
                return Optional(indexPath)
            }
        
        let longPressedCellSource = input.longPressEnded
            .asObservable()
            .compactMap { $0 }
            .withUnretained(self)
            .map { owner, indexPath in
                let project = owner.projectList.value[indexPath.row]
                return (owner, project)
            }
            .map { owner, project in
                let viewModel = ChangeStateViewModel(sourceProject: project, useCase: owner.useCase)
                viewModel.delegate = owner.parent
                return viewModel
            }
        
        return Output(projectListFetched: projectListFetched,
                      updateProjectViewPresented: updateProjectViewPresented,
                      deleteProject: deleteProject,
                      longPressedCellSource: longPressedCellSource)
    }
}
