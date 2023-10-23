//
//  ProjectHistoryManager.swift
//  ProjectManager
//
//  Created by Rowan on 2023/10/23.
//

import Foundation

protocol HistoryType {
    associatedtype Action
}

protocol HistoryRecordable {
    associatedtype RecordableItem
    associatedtype History: HistoryType
    
    func recordHistory(of recordable: RecordableItem, action: History.Action)
    func histories() -> [History]
}
