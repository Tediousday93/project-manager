//
//  CoreDataRepresentable.swift
//  ProjectManager
//
//  Created by Rowan on 2023/09/08.
//

import Foundation
import CoreData

protocol CoreDataRepresentable: AnyObject, NSManagedObject {
    associatedtype Domain
    
    static func fetchRequest() -> NSFetchRequest<Self>
}
