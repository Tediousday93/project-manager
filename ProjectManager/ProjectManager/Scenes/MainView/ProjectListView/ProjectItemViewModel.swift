//
//  ProjectItemViewModel.swift
//  ProjectManager
//
//  Created by Rowan on 2023/09/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ProjectItemViewModel {
    private let dateFormatter: DateFormatter
    
    init(dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
    }
}

extension ProjectItemViewModel: ViewModelType {
    struct Input {
        let project: Observable<Project>
    }
    
    struct Output {
        let title: Observable<String>
        let body: Observable<String>
        let dateString: Observable<String>
        let isDateExpired: Observable<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let title = input.project.map { $0.title }
        
        let body = input.project.map { $0.body }
        
        let dateString = input.project.map { $0.date }
            .withUnretained(self)
            .map { owner, date in
                owner.dateFormatter.string(from: date)
            }
        
        let isDateExpired = input.project.map { $0.date }
            .map { $0.compare(Date()) }
            .map { compareResult in
                compareResult == .orderedAscending
            }
        
        return Output(title: title,
                      body: body,
                      dateString: dateString,
                      isDateExpired: isDateExpired)
    }
}

