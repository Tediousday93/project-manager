//
//  AbstractEditViewModel.swift
//  ProjectManager
//
//  Created by Rowan on 2023/08/30.
//

import Foundation
import RxSwift
import RxCocoa

protocol EditViewModelDelegate {
    func projectCreated(at state: Project.State)
    func projectUpdated()
}

class AbstractEditViewModel: ViewModelType {
    struct Input {
        let title: Driver<String>
        let date: Driver<Date>
        let body: Driver<String>
        let rightBarButtonTapped: Driver<Void>
        let leftBarButtonTapped: Driver<Void>
    }
    
    struct Output {
        let canSave: Driver<Bool>
        let projectSave: Observable<Void>
        let canEdit: Driver<Bool>
        let dismiss: Driver<Void>
    }
    
    let navigator: EditProjectNavigator
    let useCase: ProjectListUseCaseType
    let leftBarButtonTitle: String
    
    init(navigator: EditProjectNavigator,
         useCase: ProjectListUseCaseType,
         leftBarButtonTitle: String) {
        self.navigator = navigator
        self.useCase = useCase
        self.leftBarButtonTitle = leftBarButtonTitle
    }
    
    func transform(_ input: Input) -> Output {
        fatalError("Do not use abstract method.")
    }
}
