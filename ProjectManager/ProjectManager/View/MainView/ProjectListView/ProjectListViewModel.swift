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
        return projectList
            .value
            .map { $0.id }
    }
    
    private let useCase: ProjectListUseCaseType

    init(useCase: ProjectListUseCaseType) {
        self.useCase = useCase
    }
    
    func retrieveProject(for identifier: UUID) -> Project? {
        return projectList
            .value
            .first { $0.id == identifier }
    }
}

extension ProjectListViewModel: ViewModelType {
    struct Input {
        let viewWillAppearEvent: Observable<Void>
    }
    
    struct Output {
        let dataFetched: Observable<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let dataFetched =  input.viewWillAppearEvent
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.useCase.projectList()
                    .withUnretained(owner)
            }
            .map { owner, projectList in
                owner.projectList
                    .accept(projectList)
            }
        
        return Output(
            dataFetched: dataFetched
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
