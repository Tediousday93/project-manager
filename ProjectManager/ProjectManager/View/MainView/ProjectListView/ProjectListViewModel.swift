//
//  ProjectListViewModel.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/13.
//

import Foundation
import RxSwift
import RxRelay

final class ProjectListViewModel {
    enum ProjectListEvent {
        case added
        case updated(id: UUID)
        case deleted(id: UUID)
    }
    
    typealias ProjectContents = (title: String, date: Date, body: String)
    
    let projectListEvent: PublishRelay<ProjectListEvent> = .init()
    let projectList: BehaviorRelay<[Project]> = .init(value: [])
    
    var projectIDList: [Project.ID] {
        return usecase.projectIDList()
    }
    
    private let usecase: ProjectListUsecaseType

    init(usecase: ProjectListUsecaseType) {
        self.usecase = usecase
    }
    
    func retrieveProject(for identifier: UUID) -> Project? {
        return usecase.retrieveProject(for: identifier)
    }
}

extension ProjectListViewModel: ViewModelType {
    struct Input {
        let viewWillAppearEvent: Observable<Void>
    }
    
    struct Output {
        let initialDataPassed: Observable<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let initialDataPassed =  input.viewWillAppearEvent
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.usecase.getAllProject()
                    .withUnretained(owner)
            }
            .map { owner, projectList in
                owner.projectList
                    .accept(projectList)
            }
        
        return Output(
            initialDataPassed: initialDataPassed
        )
    }
}

extension ProjectListViewModel: EditViewModelDelegate {
    func createProject(title: String, date: Date, body: String) {
        usecase.createProject(title: title, date: date, body: body)
    }
    
    func updateProject(at id: UUID, with inputContents: AbstractEditViewModel.InputContents) {
        usecase.updateProject(for: id, with: inputContents)
    }
}
