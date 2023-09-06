//
//  MainViewModel.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/12.
//

import Foundation
import RxSwift
import RxCocoa
// 책임 분리 -> Usecase 사용 기능 / Children을 관리하는 container의 기능

final class MainViewModel {
    private var children: [ProjectListViewModel] = []
    private let usecase: MainUsecaseType
    
    init(usecase: MainUsecaseType) {
        self.usecase = usecase
    }
}

extension MainViewModel: ViewModelType {
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let addBarButtonTapped: Observable<Void>
    }
    
    struct Output {
        let projectListViewModels: Observable<[ProjectListViewModel]>
        let editViewModel: Driver<CreateProjectViewModel>
    }
    
    func transform(_ input: Input) -> Output {
        let projectListViewModels = input.viewWillAppearEvent
            .withUnretained(self)
            .map { owner, _ in
                return (owner, owner.usecase.projectListUsecases())
            }
            .map { owner, projectListUsecases in
                let viewModels = projectListUsecases.map { ProjectListViewModel(usecase: $0) }
                owner.addChildren(viewModels)
                
                return viewModels
            }
        let editViewModel = input.addBarButtonTapped
            .withUnretained(self)
            .map { owner, _ in
                let editViewModel = CreateProjectViewModel(usecase: CreateProjectUsecase())
                editViewModel.delegate = owner.children[0]
                
                return editViewModel
            }
            .asDriver(onErrorJustReturn: CreateProjectViewModel(usecase: CreateProjectUsecase()))
        
        return Output(
            projectListViewModels: projectListViewModels,
            editViewModel: editViewModel
        )
    }
    
    private func addChildren(_ children: [ProjectListViewModel]) {
        children.forEach { [weak self] child in
            guard let self else { return }
            
            self.children.append(child)
        }
    }
}
