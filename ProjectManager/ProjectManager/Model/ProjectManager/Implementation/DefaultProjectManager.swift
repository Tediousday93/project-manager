//
//  DefaultProjectManager.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/13.
//

import Foundation

final class DefaultProjectManager: ProjectManagable {
    private var projectList: [Project]
    
    init(projectList: [Project] = []) {
        self.projectList = projectList
    }
    
    func createProject(title: String, date: Date, body: String) {
        let newProject = Project(title: title,
                                 date: date,
                                 body: body,
                                 state: .todo,
                                 id: UUID())
        projectList.append(newProject)
    }
    
    func getProject(for id: UUID) -> Project? {
        return projectList
            .filter { $0.id == id }
            .first
    }
    
    func getAllProject() -> [Project] {
        return projectList
    }
    
    func updateProject(for editedProject: Project) {
        guard let index = projectList.firstIndex(where: { $0.id == editedProject.id }) else {
            return
        }
        projectList[index] = editedProject
    }
    
    func deleteProject(for id: UUID) {
        guard let index = projectList.firstIndex(where: { $0.id == id }) else {
            return
        }
        projectList.remove(at: index)
    }
}
