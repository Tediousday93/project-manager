//
//  UpdateProjectViewModel.swift
//  ProjectManager
//
//  Created by Rowan on 2023/08/30.
//

import Foundation
import RxSwift
import RxCocoa

final class UpdateProjectViewModel: AbstractEditViewModel {
    enum SaveError: Error {
        case nilSourceProject
    }
    
    override func transform(_ input: AbstractEditViewModel.Input) -> AbstractEditViewModel.Output {
        let projectContents = Driver.combineLatest(input.title, input.date, input.body)
        
        let canSave = projectContents
            .map { [unowned self] title, date, body in
                return title != sourceProject?.title || body != sourceProject?.body || date != sourceProject?.date
            }
            .asDriver(onErrorJustReturn: false)
        
        let projectSave = input.rightBarButtonTapped
            .asObservable()
            .withLatestFrom(projectContents)
            .map { [unowned self] title, date, body in
                guard let sourceProject else {
                    throw SaveError.nilSourceProject
                }
                
                return Project(title: title,
                               date: date,
                               body: body,
                               state: sourceProject.state,
                               id: sourceProject.id)
            }
            .map { [unowned self] project in
                try useCase.update(project: project)
                delegate?.updateTrigger.accept(())
            }
            .share()
        
        let canEdit = input.leftBarButtonTapped
            .map { true }
            .startWith(false)
        
        let dismiss = projectSave
            .asDriver(onErrorJustReturn: ())
            .do(onNext: navigator.toMain)
        
        return Output(canSave: canSave,
                      projectSave: projectSave,
                      canEdit: canEdit,
                      dismiss: dismiss)
    }
}
