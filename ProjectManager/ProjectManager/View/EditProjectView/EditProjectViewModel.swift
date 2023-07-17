//
//  EditProjectViewModel.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/17.
//

import Foundation
import RxSwift

final class EditProjectViewModel {
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
    
    private var title: String?
    private var date: Date?
    private var body: String?
    private let state: Project.State
    private let id: UUID
    
    init(from project: Project?) {
        self.title = project?.title
        self.date = project?.date ?? Date()
        self.body = project?.body
        self.state = project?.state ?? .todo
        self.id = project?.id ?? UUID()
        
        switch project {
        case .none:
            self.mode = .create
        case .some:
            self.mode = .edit
        }
    }
}

extension EditProjectViewModel: ViewModelType {
    struct Input { }
    struct Output { }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
