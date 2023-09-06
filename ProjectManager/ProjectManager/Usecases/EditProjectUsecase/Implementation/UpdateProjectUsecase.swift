//
//  UpdateProjectUsecase.swift
//  ProjectManager
//
//  Created by Rowan on 2023/08/29.
//

final class UpdateProjectUsecase: EditProjectUsecaseType {
    var leftButtonTitle: String {
        return "Edit"
    }
    
    let sourceProject: Project?
    
    init(sourceProject: Project) {
        self.sourceProject = sourceProject
    }
}
