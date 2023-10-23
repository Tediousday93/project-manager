//
//  ProjectHistory.swift
//  ProjectManager
//
//  Created by Rowan on 2023/10/19.
//

import Foundation

struct ProjectHistory: Identifiable, Equatable, HistoryType {
    enum Action: Equatable {
        case added
        case moved(changedState: Project.State)
        case updated
        case removed
        
        var toMessageString: String {
            switch self {
            case .added:
                return "Added"
            case .moved(_):
                return "Moved"
            case .updated:
                return "Updated"
            case .removed:
                return "Removed"
            }
        }
    }
    
    let project: Project
    let action: Action
    let date: Date
    let id: UUID
    
    var informationText: String {
        switch action {
        case .added, .updated, .removed:
            return "\(action.toMessageString) '\(project.title)' from \(project.state.rawValue)"
        case .moved(let changedState):
            return "\(action.toMessageString) '\(project.title)' from \(project.state.rawValue) to \(changedState.rawValue)"
        }
    }
}
