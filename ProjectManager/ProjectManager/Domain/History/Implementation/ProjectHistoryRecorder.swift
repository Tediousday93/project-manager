//
//  ProjectHistoryRecorder.swift
//  ProjectManager
//
//  Created by Rowan on 2023/10/23.
//

import Foundation

final class ProjectHistoryRecorder: HistoryRecordable {
    typealias RecordableItem = Project
    typealias History = ProjectHistory
    
    private var historyList: [History] = []
    
    func recordHistory(of recordable: RecordableItem, action: History.Action) {
        let history = History(project: recordable, action: action, date: Date(), id: UUID())
        historyList.append(history)
    }
    
    func histories() -> [History] {
        return historyList.reversed()
    }
}
