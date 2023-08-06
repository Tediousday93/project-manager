//
//  EditViewModel.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/17.
//

import Foundation
import RxSwift

protocol EditViewModelDelegate {
    
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
    
    let mode: Mode
    var delegate: EditViewModelDelegate?
    
    private var title: String?
    private var date: Date?
    private var body: String?
    private let state: Project.State
    private let id: UUID
    
    init(from project: Project? = nil) {
        switch project {
        case .none:
            self.mode = .create
        case .some:
            self.mode = .edit
        }
        
        self.title = project?.title
        self.date = project?.date ?? Date()
        self.body = project?.body
        self.state = project?.state ?? .todo
        self.id = project?.id ?? UUID()
    }
}

extension EditViewModel: ViewModelType {
    struct Input {
        let rightBarButtonTapped: Observable<Void>
    }
    
    struct Output {
        let projectCreated: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        let projectCreated = input.rightBarButtonTapped
            .withUnretained(self)
            .map { owner, _ in
                let project = owner.createProject()
            }
        
        return Output(projectCreated: projectCreated)
    }
    
    private func createProject() -> Project? {
        guard let title, let date, let body else { return nil }
        
        return Project(title: title,
                       date: date,
                       body: body,
                       state: self.state,
                       id: self.id)
    }
}
