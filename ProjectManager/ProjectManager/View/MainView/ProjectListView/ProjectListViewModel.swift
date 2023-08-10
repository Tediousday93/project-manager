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
    
    var projectIDList: [UUID] {
        return projectList.map { $0.id }
    }
    
    let projectListEventRelay: PublishRelay<ProjectListEvent> = .init()
    let projectState: Project.State
    private(set) var projectList: [Project]
    
    init(projectState: Project.State, projectList: [Project] = []) {
        self.projectState = projectState
        self.projectList = projectList
    }
    
    func retrieveProject(for id: UUID) -> Project? {
        return projectList.first { $0.id == id }
    }
    
    func add(project: Project) {
        projectList.append(project)
        projectListEventRelay.accept(.added)
    }
    
    func updateProject(with newProject: Project) {
        guard let index = projectList.firstIndex(where: { $0.id == newProject.id }) else {
            return
        }
        
        projectList[index] = newProject
        projectListEventRelay.accept(.updated(id: newProject.id))
    }
    
    func deleteProject(id: UUID) {
        guard let index = projectList.firstIndex(where: { $0.id == id }) else {
            return
        }
        
        projectList.remove(at: index)
        projectListEventRelay.accept(.deleted(id: id))
    }
}

extension ProjectListViewModel: EditViewModelDelegate { }
