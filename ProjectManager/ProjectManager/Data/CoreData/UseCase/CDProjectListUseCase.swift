//
//  CDProjectUseCase.swift
//  ProjectManager
//
//  Created by Rowan on 2023/09/14.
//

import Foundation
import RxSwift

final class ProjectListUseCase<Repository>: ProjectListUseCaseType where Repository: CoreDataRepositoryType, Repository.T == Project {
    private let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    func projectList(for state: Project.State? = nil) -> Observable<[Project]> {
        var predicate: NSPredicate? = nil
        
        if let state {
            predicate = NSPredicate(format: "state == %@", state.rawValue)
        }
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        
        return repository.fetchObjects(sortDescriptors: [sortDescriptor], predicate: predicate)
    }
    
    func create(project: Project) throws {
        try repository.create(object: project)
    }
    
    func update(project: Project) throws {
        let predicate = NSPredicate(format: "id == %@", project.id.uuidString)
        try repository.update(object: project, with: predicate)
    }
    
    func delete(project: Project) throws {
        let predicate = NSPredicate(format: "id == @%", project.id.uuidString)
        try repository.delete(object: project, with: predicate)
    }
}
