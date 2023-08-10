//
//  EditViewModel.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/17.
//

import Foundation
import RxSwift

protocol EditViewModelDelegate {
    func add(project: Project)
}

final class EditViewModel {
    enum Mode {
        case create
        case edit
        
        var leftBarButtonTitle: String {
            switch self {
            case .create:
                return "Cancel"
            case .edit:
                return "Edit"
            }
        }
    }
    
    var delegate: EditViewModelDelegate?
    
    let mode: Mode
    let projectState: Project.State
    private var title: String
    private var date: Date
    private var body: String
    private let id: UUID
    private let sourceProject: Project?
    
    init(from project: Project? = nil) {
        switch project {
        case .none:
            self.mode = .create
        case .some:
            self.mode = .edit
        }
        
        self.title = project?.title ?? ""
        self.date = project?.date ?? Date()
        self.body = project?.body ?? ""
        self.projectState = project?.state ?? .todo
        self.id = project?.id ?? UUID()
        self.sourceProject = project
    }
}

extension EditViewModel {
    struct Input {
        let rightBarButtonTapped: Observable<Void>
        let titleText: Observable<String>
        let pickedDate: Observable<Date>
        let bodyText: Observable<String>
    }
    
    struct Output {
        let projectCreated: Observable<Void>
        let isContentEdited: Observable<Bool>
    }
    
    func transform(_ input: Input, with disposeBag: DisposeBag) -> Output {
        let projectCreated = input.rightBarButtonTapped
            .withUnretained(self)
            .map { owner, _ in
                let project = owner.createProject()
                owner.delegate?.add(project: project)
            }
        let isTitleEdited = input.titleText
            .withUnretained(self)
            .map { owner, title in
                owner.title = title
                let oldTitle = owner.sourceProject?.title ?? ""
                return owner.title == oldTitle ? false : true
            }
        let isBodyEdited = input.bodyText
            .withUnretained(self)
            .map { owner, body in
                owner.body = body
                let oldBody = owner.sourceProject?.body ?? ""
                return owner.body == oldBody ? false : true
            }
        let isContentEdited = Observable.combineLatest(isTitleEdited, isBodyEdited)
            .map { (isTitleEdited, isBodyEdited) in
                isTitleEdited || isBodyEdited
            }
        
        // 이게 최선인가?
        input.pickedDate
            .withUnretained(self)
            .map { owner, date in
                owner.date = date
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        return Output(projectCreated: projectCreated,
                      isContentEdited: isContentEdited)
    }
    
    private func createProject() -> Project {
        return Project(title: title,
                       date: date,
                       body: body,
                       state: projectState,
                       id: id)
    }
}
