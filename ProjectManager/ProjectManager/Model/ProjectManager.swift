//
//  ProjectManager.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/13.
//

import Foundation

// Service -> DB, persistence Storing
// UseCase -> Project CRUD

final class ProjectManager {
    private(set) var projectList: [Project]
    
    init(projectList: [Project] = []) {
        self.projectList = projectList
    }
    
    func createProject(title: String, date: Date, body: String) {
        let newProject = Project(title: title, date: date, body: body, state: .todo, id: UUID())
        projectList.append(newProject)
    }
    
    func getProject(id: UUID) -> Project? {
        projectList
            .filter { $0.id == id }
            .first
    }
    
    func updateProject(with project: Project) {
        guard let index = projectList.firstIndex(of: project) else {
            return
        }
        projectList[index] = project
    }
    
    func deleteProject(id: UUID) {
        guard let index = projectList.firstIndex(where: { $0.id == id }) else {
            return
        }
        projectList.remove(at: index)
    }
}
