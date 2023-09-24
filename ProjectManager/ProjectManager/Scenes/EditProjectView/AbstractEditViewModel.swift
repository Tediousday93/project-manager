//
//  AbstractEditViewModel.swift
//  ProjectManager
//
//  Created by Rowan on 2023/08/30.
//

import Foundation
import RxSwift
import RxCocoa

protocol EditViewModelDelegate: AnyObject {
    var updateTrigger: BehaviorRelay<Void> { get }
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
    
    weak var delegate: EditViewModelDelegate?
    
    let navigator: EditProjectNavigator
    let useCase: ProjectListUseCaseType
    let leftBarButtonTitle: String
    let sourceProject: Project?
    
    init(navigator: EditProjectNavigator,
         useCase: ProjectListUseCaseType,
         leftBarButtonTitle: String,
         sourceProject: Project?) {
        self.navigator = navigator
        self.useCase = useCase
        self.leftBarButtonTitle = leftBarButtonTitle
        self.sourceProject = sourceProject
    }
    
    func transform(_ input: Input) -> Output {
        fatalError("Do not use abstract method.")
    }
}
