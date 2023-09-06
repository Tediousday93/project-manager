//
//  MainUsecase.swift
//  ProjectManager
//
//  Created by Rowan on 2023/08/29.
//

final class MainUsecase: MainUsecaseType {
    func projectListUsecases() -> [ProjectListUsecaseType] {
        var usecaseList: [ProjectListUsecaseType] = []
        let todoManager = DefaultProjectManager()
        let doingManager = DefaultProjectManager()
        let doneManager = DefaultProjectManager()
        usecaseList.append(ProjectListUsecase(projectState: .todo, projectManager: todoManager))
        usecaseList.append(ProjectListUsecase(projectState: .doing, projectManager: doingManager))
        usecaseList.append(ProjectListUsecase(projectState: .done, projectManager: doneManager))
        
        return usecaseList
    }
}
