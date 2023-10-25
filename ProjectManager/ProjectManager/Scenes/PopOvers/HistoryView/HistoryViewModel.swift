//
//  HistoryViewModel.swift
//  ProjectManager
//
//  Created by Rowan on 2023/10/23.
//

import Foundation
import RxSwift
import RxCocoa

final class HistoryViewModel {
    private let historyRecorder: any HistoryRecordable
    
    init(historyRecorder: any HistoryRecordable) {
        self.historyRecorder = historyRecorder
    }
}

extension HistoryViewModel: ViewModelType {
    struct Input {
        let viewWillAppearEvent: Observable<Void>
    }
    
    struct Output {
        
    }
    
    func transform(_ input: Input) -> Output {
        
        
        return Output()
    }
}
