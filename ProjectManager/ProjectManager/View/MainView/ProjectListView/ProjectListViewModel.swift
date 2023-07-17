//
//  ProjectListViewModel.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/13.
//

import Foundation

final class ProjectListViewModel {
    private let projectState: Project.State
    private let projectManager: ProjectManager
    
    init(projectState: Project.State, projectManager: ProjectManager) {
        self.projectState = projectState
        self.projectManager = projectManager
    }
}
