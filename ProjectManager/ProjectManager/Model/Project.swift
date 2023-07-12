//
//  Project.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/12.
//

import Foundation

struct Project: Equatable {
    enum State: String {
        case todo = "TODO"
        case doing = "DOING"
        case done = "DONE"
    }
    
    let title: String
    let date: Date
    let body: String
    let state: State
    let id: UUID
}
