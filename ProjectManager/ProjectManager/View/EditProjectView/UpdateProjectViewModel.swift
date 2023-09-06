//
//  UpdateProjectViewModel.swift
//  ProjectManager
//
//  Created by Rowan on 2023/08/30.
//

import Foundation
import RxSwift

final class UpdateProjectViewModel: AbstractEditViewModel {
    override func transform(_ input: AbstractEditViewModel.Input) -> AbstractEditViewModel.Output {
        let projectDelegated = Observable
            .combineLatest(input.rightBarButtonTapped, input.projectContents)
            .map { _, projectContents in
                return projectContents
            }
            .withUnretained(self)
            .map { owner, projectContents in
                guard let delegate = owner.delegate,
                      let projectID = owner.usecase.sourceProject?.id else { return }
                
                delegate.updateProject(at: projectID, with: projectContents)
            }
            
        let isContentEdited = input.projectContents
            .withUnretained(self)
            .map { owner, projectContents in
                return owner.usecase.check(inputText: (projectContents.title, projectContents.body))
            }
        
        return Output(projectDelegated: projectDelegated,
                      isContentEdited: isContentEdited)
    }
}
