//
//  CDUseCaseProvider.swift
//  ProjectManager
//
//  Created by Rowan on 2023/09/14.
//

final class CDUseCaseProvider: UseCaseProvider {
    private let coreDataStack = CoreDataStack()
    private let projectRepository: CoreDataRepository<Project>
    
    init() {
        projectRepository = CoreDataRepository<Project>(coreDataStack: coreDataStack)
    }
    
    func makeProjectListUseCase() -> ProjectListUseCaseType {
        return CDProjectListUseCase(repository: projectRepository)
    }
}
