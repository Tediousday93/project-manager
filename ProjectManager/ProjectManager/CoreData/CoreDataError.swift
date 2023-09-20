//
//  CoreDataError.swift
//  ProjectManager
//
//  Created by Rowan on 2023/09/14.
//

import Foundation

enum CoreDataError: Error {
    case fetchFailed
    case entityCreationFailed
    case entityNotFound
}
