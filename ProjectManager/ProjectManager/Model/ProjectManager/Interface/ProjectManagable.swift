//
//  ProjectManagable.swift
//  ProjectManager
//
//  Created by Rowan on 2023/08/18.
//

import Foundation

protocol ProjectManagable {
    func createProject(title: String, date: Date, body: String)
    func getProject(for id: UUID) -> Project?
    func getAllProject() -> [Project]
    func updateProject(for editedProject: Project)
    func deleteProject(for id: UUID)
}

