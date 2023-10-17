//
//  ChangeStateViewModel.swift
//  ProjectManager
//
//  Created by Rowan on 2023/09/26.
//

import Foundation
import RxSwift
import RxCocoa

protocol ChangeStateViewModelDelegate: AnyObject {
    func updateListView(states: [Project.State])
}

final class ChangeStateViewModel {
    weak var delegate: ChangeStateViewModelDelegate?
    
    private let sourceProject: Project
    private let useCase: ProjectListUseCaseType
    
    init(sourceProject: Project,
         useCase: ProjectListUseCaseType) {
        self.sourceProject = sourceProject
        self.useCase = useCase
    }
}

extension ChangeStateViewModel: ViewModelType {
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let firstButtonTapped: Observable<String>
        let secondButtonTapped: Observable<String>
    }
    
    struct Output {
        let buttonTitles: Driver<[String]>
        let stateChanged: Observable<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let buttonTitles = input.viewWillAppearEvent
            .withUnretained(self)
            .map { owner, _ in
                var stateList = Project.State.allCases
                stateList.remove { $0 == owner.sourceProject.state }
                
                return stateList
            }
            .map { stateList in
                stateList.map { $0.rawValue }
            }
            .asDriver(onErrorJustReturn: Project.State.allCases.map { $0.rawValue })
        
        let stateChanged = Observable<String>.merge(input.firstButtonTapped,
                                                    input.secondButtonTapped)
            .compactMap { string in
                Project.State.init(rawValue: string)
            }
            .withUnretained(self)
            .map { owner, state in
                let changedProject = Project(title: owner.sourceProject.title,
                                             date: owner.sourceProject.date,
                                             body: owner.sourceProject.body,
                                             state: state,
                                             id: owner.sourceProject.id)
                
                try owner.useCase.update(project: changedProject)
                owner.delegate?.updateListView(states: [state, owner.sourceProject.state])
            }
        
        return Output(buttonTitles: buttonTitles,
                      stateChanged: stateChanged)
    }
}
