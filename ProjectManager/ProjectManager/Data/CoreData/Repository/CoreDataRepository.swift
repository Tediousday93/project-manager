//
//  CoreDataRepository.swift
//  ProjectManager
//
//  Created by Rowan on 2023/09/06.
//

import Foundation
import CoreData

protocol CoreDataRepositoryType {
    associatedtype T
    associatedtype SortDescription
    
    func create(object: T)
    func readAll(sortDescriptions: [SortDescription]) -> [T]
    func update(object: T, with predicate: NSPredicate)
    func delete(object: T, with predicate: NSPredicate)
}

final class CoreDataRepository<T: CoreDataRepresentable>: CoreDataRepositoryType where T == T.CoreDataType.DomainType {
    struct SortDescription {
        let key: String
        let ascending: Bool
    }
    
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func create(object: T) {
        guard let entityName = T.CoreDataType.entity().name,
              let entityDescription = NSEntityDescription.entity(forEntityName: entityName,
                                                                 in: coreDataStack.context),
              let coreDataEntity = NSManagedObject(entity: entityDescription,
                                           insertInto: coreDataStack.context) as? T.CoreDataType
        else {
            fatalError("Fail to create coredata entity")
        }
        
        object.update(entity: coreDataEntity)
        coreDataStack.saveContext()
    }
    
    func readAll(sortDescriptions: [SortDescription]) -> [T] {
        let request = T.CoreDataType.fetchRequest()
        let sortDescriptors = sortDescriptions
            .map { NSSortDescriptor(key: $0.key, ascending: $0.ascending) }
        request.sortDescriptors = sortDescriptors
        
        let fetchResult = coreDataStack.fetch(request: request)
        
        return fetchResult.map { $0.toDomain() }
    }
    
    func update(object: T, with predicate: NSPredicate) {
        let request = T.CoreDataType.fetchRequest()
        request.predicate = predicate
        let fetchResult = coreDataStack.fetch(request: request)
        
        guard let coreDataEntity = fetchResult.first else {
            return
        }
        
        object.update(entity: coreDataEntity)
        coreDataStack.saveContext()
    }
    
    func delete(object: T, with predicate: NSPredicate) {
        let request = T.CoreDataType.fetchRequest()
        request.predicate = predicate
        let fetchResult = coreDataStack.fetch(request: request)
        
        guard let coreDataEntity = fetchResult.first else {
            return
        }
        
        coreDataStack.delete(object: coreDataEntity)
    }
}
