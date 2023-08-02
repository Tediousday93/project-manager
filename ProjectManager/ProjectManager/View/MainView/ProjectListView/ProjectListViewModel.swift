//
//  ProjectListViewModel.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/13.
//

import Foundation
import RxSwift

final class ProjectListViewModel {
    let projectState: Project.State
    
    var projectIDList: [UUID] {
        return projectList.map { $0.id }
    }
    
    let projectCreated: PublishSubject<Void> = .init()
    let projectUpdated: PublishSubject<UUID> = .init()
    let projectDeleted: PublishSubject<UUID> = .init()
    
    private(set) var projectList: [Project] = []
    
    init(projectState: Project.State) {
        self.projectState = projectState
    }
    
    func retriveProject(for id: UUID) -> Project? {
        return projectList
            .filter { $0.id == id }
            .first
    }
    
    func createProject() {
        
    }
}

extension ProjectListViewModel: ViewModelType {
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}

