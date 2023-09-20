//
//  CoreDataRepresentable.swift
//  ProjectManager
//
//  Created by Rowan on 2023/09/08.
//

import Foundation
import CoreData

protocol DomainConvertible {
    associatedtype DomainType
    
    func toDomain() -> DomainType
}

protocol CoreDataRepresentable {
    associatedtype CoreDataType: Persistable
    
    func update(entity: CoreDataType)
}
