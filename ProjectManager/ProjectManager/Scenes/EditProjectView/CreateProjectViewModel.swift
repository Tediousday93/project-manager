//
//  CreateProjectViewModel.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/17.
//

import Foundation
import RxSwift
import RxCocoa

final class CreateProjectViewModel: AbstractEditViewModel {
    override func transform(_ input: AbstractEditViewModel.Input) -> AbstractEditViewModel.Output {
        let projectContents = Driver.combineLatest(input.title,
                                                   input.date,
                                                   input.body)
        let canSave = projectContents.map { title, date, body in
            return title != "" || body != ""
        }
        
        let projectSave = input.rightBarButtonTapped
            .asObservable()
            .withLatestFrom(projectContents)
            .map { title, date, body in
                return Project(title: title,
                               date: date,
                               body: body,
                               state: .todo,
                               id: UUID())
            }
            .map { [unowned self] project in
                try self.useCase.create(project: project)
            }
        
        let canEdit = Driver.just(true)
        
        let dismiss = Driver.merge(input.leftBarButtonTapped,
                                       projectSave.asDriver(onErrorJustReturn: ()))
            .do(onNext: navigator.toMain)
        
        return Output(canSave: canSave,
                      projectSave: projectSave,
                      canEdit: canEdit,
                      dismiss: dismiss)
    }
}
