//
//  Project.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/12.
//

import Foundation

struct Project: Equatable {
    enum State {
        case todo
        case doing
        case done
    }
    
    let title: String
    let date: Date
    let body: String
    let state: State
    let id: UUID
}
