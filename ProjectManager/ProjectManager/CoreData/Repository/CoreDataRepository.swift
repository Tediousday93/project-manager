//
//  CoreDataRepository.swift
//  ProjectManager
//
//  Created by Rowan on 2023/09/06.
//

import Foundation
import CoreData
import RxSwift

protocol CoreDataRepositoryType {
    associatedtype T
    
    func create(object: T) throws
    func fetchObjects(sortDescriptors: [NSSortDescriptor], predicate: NSPredicate?) -> Single<[T]>
    func update(object: T, with predicate: NSPredicate) throws
    func delete(object: T, with predicate: NSPredicate) throws
}

final class CoreDataRepository<T: CoreDataRepresentable>: CoreDataRepositoryType where T == T.CoreDataType.DomainType {
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func create(object: T) throws {
        guard let entityName = T.CoreDataType.entity().name,
              let entityDescription = NSEntityDescription.entity(forEntityName: entityName,
                                                                 in: coreDataStack.context),
              let coreDataEntity = NSManagedObject(entity: entityDescription,
                                           insertInto: coreDataStack.context) as? T.CoreDataType
        else {
            throw CoreDataError.entityCreationFailed
        }
        
        object.update(entity: coreDataEntity)
        coreDataStack.saveContext()
    }
    
    func fetchObjects(sortDescriptors: [NSSortDescriptor], predicate: NSPredicate? = nil) -> Single<[T]> {
        return Single<[T]>.create { [weak self] single in
            let request = T.CoreDataType.fetchRequest()
            request.sortDescriptors = sortDescriptors
            request.predicate = predicate
            
            guard let fetchResult = try? self?.coreDataStack.fetch(request: request) else {
                single(.failure(CoreDataError.fetchFailed))
                return Disposables.create()
            }
            
            let projectList = fetchResult.map { $0.toDomain() }
            single(.success(projectList))
            
            return Disposables.create()
        }
    }
    
    func update(object: T, with predicate: NSPredicate) throws {
        let request = T.CoreDataType.fetchRequest()
        request.predicate = predicate
        let fetchResult = try coreDataStack.fetch(request: request)
        
        guard let coreDataEntity = fetchResult.first else {
            throw CoreDataError.entityNotFound
        }
        
        object.update(entity: coreDataEntity)
        coreDataStack.saveContext()
    }
    
    func delete(object: T, with predicate: NSPredicate) throws {
        let request = T.CoreDataType.fetchRequest()
        request.predicate = predicate
        let fetchResult = try coreDataStack.fetch(request: request)
        
        guard let coreDataEntity = fetchResult.first else {
            throw CoreDataError.entityNotFound
        }
        
        coreDataStack.delete(object: coreDataEntity)
    }
}
