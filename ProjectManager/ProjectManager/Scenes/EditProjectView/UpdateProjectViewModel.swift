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
    override func transform(_ input: AbstractEditViewModel.Input) -> AbstractEditViewModel.Output {
        
        
        return Output(canSave: Driver.just(false), projectSave: Observable.just(()), canEdit: Driver.just(false), dismiss: Driver.just(()))
    }
}
