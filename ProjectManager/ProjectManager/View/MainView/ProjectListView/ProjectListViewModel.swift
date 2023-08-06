//
//  ProjectListViewModel.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/13.
//

import Foundation
import RxSwift

final class ProjectListViewModel {
    enum ProjectListEvent {
        case added
        case updated(id: UUID)
        case deleted(id: UUID)
    }
    
    var projectIDList: [UUID] {
        return projectList.map { $0.id }
    }
    
    let projectListSubject: PublishSubject<ProjectListEvent> = .init()
    let projectState: Project.State
    private(set) var projectList: [Project]
    
    init(projectState: Project.State, projectList: [Project] = []) {
        self.projectState = projectState
        self.projectList = projectList
    }
    
    func retriveProject(for id: UUID) -> Project? {
        return projectList
            .filter { $0.id == id }
            .first
    }
    
    func add(project: Project) {
        projectList.append(project)
        projectListSubject.onNext(.added)
    }
    
    func updateProject(with newProject: Project) {
        guard let index = projectList.firstIndex(where: { $0.id == newProject.id }) else {
            return
        }
        
        projectList[index] = newProject
        projectListSubject.onNext(.updated(id: newProject.id))
    }
    
    func deleteProject(id: UUID) {
        guard let index = projectList.firstIndex(where: { $0.id == id }) else {
            return
        }
        
        projectList.remove(at: index)
        projectListSubject.onNext(.deleted(id: id))
    }
}

extension ProjectListViewModel: EditViewModelDelegate { }

