//
//  CDProject+CoreDataProperties.swift
//  ProjectManager
//
//  Created by Rowan on 2023/09/22.
//
//

import Foundation
import CoreData


extension CDProject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDProject> {
        return NSFetchRequest<CDProject>(entityName: "CDProject")
    }

    @NSManaged public var title: String
    @NSManaged public var date: Date
    @NSManaged public var body: String
    @NSManaged public var state: String
    @NSManaged public var id: UUID

}

extension CDProject: Identifiable { }

extension CDProject: Persistable { }

extension CDProject: DomainConvertible {
    typealias DomainType = Project
    
    func toDomain() -> Project {
        return Project(title: title,
                       date: date,
                       body: body,
                       state: Project.State(rawValue: state) ?? .todo,
                       id: id)
    }
}

extension Project: CoreDataRepresentable {
    typealias CoreDataType = CDProject
    
    func update(entity: CDProject) {
        entity.title = title
        entity.date = date
        entity.body = body
        entity.state = state.rawValue
        entity.id = id
    }
}
