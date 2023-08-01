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
    
    private(set) var projectList: [Project] = []
    
    init(projectState: Project.State) {
        self.projectState = projectState
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

