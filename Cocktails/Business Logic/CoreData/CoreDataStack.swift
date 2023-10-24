//
//  CoreDataStack.swift
//  Cocktails
//
//  Created by Hudson Maul on 20/10/2023.
//

import Foundation
import CoreData

class CoreDataStack: NSObject {
    
    // MARK: - Props (public)

    public var isLoaded: Bool = false
    
    public var viewContext: NSManagedObjectContext {
        let context = container.viewContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    // MARK: - Props (private)

    private var container: NSPersistentContainer!

    private var storeDescription: NSPersistentStoreDescription? {
        return container.persistentStoreDescriptions.first
    }
      
    // MARK: Life cycle
        
    public func load() async throws {
        
        container = NSPersistentContainer(name: "Cocktails")
        
        return try await withCheckedThrowingContinuation { continuation in

            guard !isLoaded else {
                continuation.resume()
                return
            }

            container.loadPersistentStores{ [weak self] storeDescription, error in
                if let error = error as NSError? {
                    print("Loading core data stack failed: \(error)")
                    continuation.resume(throwing: error)
                    return
                }
                self?.isLoaded = true
                continuation.resume()
            }
        }
    }
    
    public func newBackgroundContext() -> NSManagedObjectContext {
        container.newBackgroundContext()
    }
    
    // MARK: Save

    public func saveObjects<T:NSManagedObject>(ofType: T.Type, from dictionaries: [[String:Any?]]?, idKey: String) {
        
        guard let dictionaries else { return }

        let context = newBackgroundContext()
        
        context.performAndWait {
            let localObjects:[T] = fetchObjects(in: context)
            
            dictionaries.forEach { dict in
                updateOrCreateObject(
                    from: dict, idKey: idKey, localObjects: localObjects, context: context
                )
            }
            
            save(in: context)
        }
    }

    public func save(in context: NSManagedObjectContext? = nil) {
        let aContext = context ?? container.viewContext

        guard aContext.hasChanges else { return }
        aContext.performAndWait {
            do {
                try aContext.save()
            } catch {
                print("Error saving to context: \(String(describing: context)): \(error)")

            }
        }
    }
    
    // MARK: Update

    private func updateOrCreateObject<T:NSManagedObject>(from dictionary: [String: Any?],
                                                         idKey: String,
                                                         localObjects: [T],
                                                         context: NSManagedObjectContext) {
        
        guard let id = dictionary[idKey] as? String else { return }

        let match = localObjects.filter({ $0.value(forKey: idKey) as? String == id }).first

        var managedObject: T!
        
        if let match {
            managedObject = match
        }  else {
            let entityName = String(describing:T.self)
            managedObject = (NSEntityDescription.insertNewObject(
                forEntityName: entityName,
                into: context
            ) as! T)
        }
        
        updateValues(forObject: managedObject, using: dictionary)
    }
    
    private func updateValues(forObject managedObject: NSManagedObject,
                                                 using dictionary: [String: Any?]) {
        dictionary.keys.forEach { key in
            let value = dictionary[key]
            /**
             NOTE: For the scope of this exercise, I only need to support mapping string
             values here, so I'm only casting as `NSString`. This key-value mapping can
             easily be extended to support other reference types, like `NSDate` for
             example, if I needed to persist date strings from the API as date objects.
            **/
            managedObject.setValue(value as? NSString, forKey: key)
        }
    }
    
    // MARK: Fetch

    func fetchObject<T:NSManagedObject>(byKey key: String, value: String, in context: NSManagedObjectContext? = nil) -> T? {
        let context = context ?? viewContext
        let entityName = String(describing: T.self)
        let request: NSFetchRequest<T> = NSFetchRequest(entityName: entityName)
        
        let predicate = NSPredicate(format: "%K == %@", key, value)
        request.predicate = predicate
        
        var result: T?
        context.performAndWait {
            do {
                result = try context.fetch(request).first
            } catch {
                debugPrint("Failed to fetch \(T.self): \(error)")
            }
        }
       return result
    }
    
    func fetchObjects<T:NSManagedObject>(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, in context: NSManagedObjectContext? = nil) -> [T] {
        let context = context ?? viewContext
        let entityName = String(describing: T.self)
        let request: NSFetchRequest<T> = NSFetchRequest(entityName: entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        var results = [T]()
        context.performAndWait {
            do {
                results = try context.fetch(request)
            } catch {
                debugPrint("Failed to fetch \(T.self): \(error)")
            }
        }
       return results
    }
    
    public func deleteAllObjects() {
}
