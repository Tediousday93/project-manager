//
//  CreateProjectViewModel.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/17.
//

import Foundation
import RxSwift

final class CreateProjectViewModel: AbstractEditViewModel {
    override func transform(_ input: AbstractEditViewModel.Input) -> AbstractEditViewModel.Output {
        let projectDelegated = Observable
            .combineLatest(input.rightBarButtonTapped, input.projectContents)
            .map { _, projectContents in
                return projectContents
            }
            .withUnretained(self)
            .map { owner, projectContents in
                guard let delegate = owner.delegate else { return }
                
                delegate.createProject(
                    title: projectContents.title,
                    date: projectContents.date,
                    body: projectContents.body
                )
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
