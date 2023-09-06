//
//  ProjectManagable.swift
//  ProjectManager
//
//  Created by Rowan on 2023/08/18.
//

import Foundation

protocol ProjectManagable {
    func createProject(title: String, date: Date, body: String)
    func getProject(for id: Project.ID) -> Project?
    func getAllProject() -> [Project]
    func updateProject(for id: Project.ID, title: String, date: Date, body: String)
    func deleteProject(for id: Project.ID)
}
