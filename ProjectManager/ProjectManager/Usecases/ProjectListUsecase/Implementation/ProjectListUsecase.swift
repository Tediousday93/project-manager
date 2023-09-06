//
//  ProjectListUsecase.swift
//  ProjectManager
//
//  Created by Rowan on 2023/08/29.
//

import RxSwift

final class ProjectListUsecase: ProjectListUsecaseType {
    let projectState: Project.State
    let projectManager: ProjectManagable
    
    init(projectState: Project.State,
         projectManager: ProjectManagable) {
        self.projectState = projectState
        self.projectManager = projectManager
    }
    
    func getAllProject() -> Observable<[Project]> {
        return Single.just(projectManager.getAllProject())
            .asObservable()
    }
    
    func projectIDList() -> [Project.ID] {
        return projectManager
            .getAllProject()
            .map { $0.id }
    }
    
    func retrieveProject(for identifier: UUID) -> Project? {
        return projectManager.getProject(for: identifier)
    }
    
    func createProject(title: String, date: Date, body: String) {
        projectManager.createProject(title: title, date: date, body: body)
    }
    
    func updateProject(for identifier: UUID, with contents: ProjectContents) {
        projectManager.updateProject(for: identifier,
                                     title: contents.title,
                                     date: contents.date,
                                     body: contents.body)
    }
}
