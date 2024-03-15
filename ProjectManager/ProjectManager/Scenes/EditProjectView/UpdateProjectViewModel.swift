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
    
    override func transform(_ input: Input) -> Output {
        let projectContents = Driver.combineLatest(input.title, input.date, input.body)
        
        let canSave = projectContents
            .map { [weak self] title, date, body in
                let isTitleModified = title != self?.sourceProject?.title
                let isBodyModified = body != self?.sourceProject?.body
                let isDateModified = date != self?.sourceProject?.date
                return isTitleModified || isBodyModified || isDateModified
            }
            .asDriver(onErrorJustReturn: false)
        
        let projectSave = input.rightBarButtonTapped
            .asObservable()
            .withLatestFrom(projectContents)
            .map { [weak self] title, date, body in
                guard let sourceProject = self?.sourceProject else {
                    throw SaveError.nilSourceProject
                }
                
                return Project(title: title,
                               date: date,
                               body: body,
                               state: sourceProject.state,
                               id: sourceProject.id)
            }
            .withUnretained(self)
            .map { owner, project in
                try owner.useCase.update(project: project)
                owner.updateTrigger.accept(())
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
