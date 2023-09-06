//
//  CreateProjectUsecase.swift
//  ProjectManager
//
//  Created by Rowan on 2023/08/29.
//

final class CreateProjectUsecase: EditProjectUsecaseType {
    var leftButtonTitle: String {
        return "Cancel"
    }
    
    let sourceProject: Project? = nil
}
