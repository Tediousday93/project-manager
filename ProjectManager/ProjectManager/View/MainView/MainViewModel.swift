//
//  MainViewModel.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/12.
//

import Foundation
import RxSwift

final class MainViewModel {
    private var children: [Project.State: ProjectListViewModel] = [:]
    
    func addChildren(_ children: [ProjectListViewModel]) {
        children.forEach { child in
            self.children[child.projectState] = child
        }
    }
}

extension MainViewModel: ViewModelType {
    struct Input {
        let addBarButtonTapped: Observable<Void>
    }
    
    struct Output {
        let editViewModel: Observable<EditViewModel>
    }
    
    func transform(input: Input) -> Output {
        let editViewModel = input.addBarButtonTapped
            .withUnretained(self)
            .map { owner, _ in
                let editViewModel = EditViewModel(from: nil)
                editViewModel.delegate = owner.children[.todo]
                
                return editViewModel
            }
        
        return Output(editViewModel: editViewModel)
    }
}
