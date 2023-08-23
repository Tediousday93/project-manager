//
//  EditViewModel.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/17.
//

import Foundation
import RxSwift
import RxRelay

final class EditViewModel {
    var leftBarButtonTitle: String {
        switch sourceProject {
        case .none:
            return "Cancel"
        case .some:
            return "Edit"
        }
    }
    
    let sourceProject: Project?
    
    init(from project: Project? = nil) {
        self.sourceProject = project
    }
}

extension EditViewModel {
    struct Input {
        let rightBarButtonTapped: PublishRelay<Void> = .init()
        let projectContents: PublishRelay<(title: String, date: Date, body: String)> = .init()
    }
    
    struct Output {
        let projectCreated: Observable<Void>
        let isContentEdited: Observable<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let projectCreated = Observable
            .combineLatest(input.rightBarButtonTapped, input.projectContents)
            .map { _, projectContents in
                return projectContents
            }
            .withUnretained(self)
            .map { owner, projectContents in
                let project = Project(title: projectContents.title,
                               date: projectContents.date,
                               body: projectContents.body,
                               state: owner.sourceProject?.state ?? .todo,
                               id: owner.sourceProject?.id ?? UUID())
            }
            
        let isContentEdited = input.projectContents
            .map { title, date, body in
                return (title, body)
            }
            .withUnretained(self)
            .map { owner, inputText in
                return owner.check(inputText: inputText)
            }
        
        return Output(projectCreated: projectCreated,
                      isContentEdited: isContentEdited)
    }
    
    private func check(inputText: (title: String, body: String)) -> Bool {
        let isTitleEdited = inputText.title != (sourceProject?.title ?? "")
        let isBodyEdited = inputText.body != (sourceProject?.body ?? "")
        
        return isTitleEdited || isBodyEdited
    }
}
