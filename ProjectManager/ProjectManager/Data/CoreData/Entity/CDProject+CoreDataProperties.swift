//
//  CDProject+CoreDataProperties.swift
//  ProjectManager
//
//  Created by Rowan on 2023/09/08.
//
//


import Foundation
import CoreData


extension CDProject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDProject> {
        return NSFetchRequest<CDProject>(entityName: "CDProject")
    }

    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var body: String?
    @NSManaged public var state: String?
    @NSManaged public var id: UUID?

}

extension CDProject: Identifiable { }

extension CDProject: CoreDataRepresentable {
    typealias Domain = Project
}
