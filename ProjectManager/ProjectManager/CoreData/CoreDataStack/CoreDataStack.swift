//
//  CoreDataStack.swift
//  ProjectManager
//
//  Created by Rowan on 2023/09/06.
//

import Foundation
import CoreData

final class CoreDataStack {
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) throws -> [T] {
        return try context.fetch(request)
    }
    
    func saveContext() {
        if context.hasChanges {
            let result = Result { try context.save() }
            
            switch result {
            case .success:
                return
            case .failure(let error as NSError):
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func delete<T: NSManagedObject>(object: T) {
        context.delete(object)
        saveContext()
    }
}
