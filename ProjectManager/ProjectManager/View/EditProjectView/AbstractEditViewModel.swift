//
//  AbstractEditViewModel.swift
//  ProjectManager
//
//  Created by Rowan on 2023/08/30.
//

import Foundation
import RxSwift

protocol EditViewModelDelegate {
    func createProject(title: String, date: Date, body: String)
    func updateProject(at id: UUID, with inputContents: AbstractEditViewModel.InputContents)
}

class AbstractEditViewModel: ViewModelType {
    typealias InputContents = (title: String, date: Date, body: String)
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let rightBarButtonTapped: Observable<Void>
        let projectContents: Observable<InputContents>
    }
    
    struct Output {
        let projectDelegated: Observable<Void>
        let isContentEdited: Observable<Bool>
    }
    
    var delegate: EditViewModelDelegate?
    
    let usecase: EditProjectUsecaseType
    
    init(usecase: EditProjectUsecaseType) {
        self.usecase = usecase
    }
    
    func transform(_ input: Input) -> Output {
        fatalError("Do not use")
//        return Output(projectDelegated: Observable.just(()),
//                      isContentEdited: Observable.just(true))
    }
}
