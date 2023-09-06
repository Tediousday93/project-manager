//
//  ProjectListUsecase.swift
//  ProjectManager
//
//  Created by Rowan on 2023/08/29.
//

import RxSwift

protocol ProjectListUsecaseType {
    typealias ProjectContents = (title: String, date: Date, body: String)
    var projectState: Project.State { get }
    var projectManager: ProjectManagable { get }
    
    func getAllProject() -> Observable<[Project]>
    func projectIDList() -> [Project.ID]
    func retrieveProject(for identifier: UUID) -> Project?
    func createProject(title: String, date: Date, body: String)
    func updateProject(for identifier: UUID, with contents: ProjectContents)
}
