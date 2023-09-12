//
//  Persistable.swift
//  ProjectManager
//
//  Created by Rowan on 2023/09/12.
//

import Foundation
import CoreData

protocol Persistable: AnyObject, NSManagedObject, DomainConvertible {
    static func fetchRequest() -> NSFetchRequest<Self>
}
