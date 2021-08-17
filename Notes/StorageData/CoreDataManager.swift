//
//  CoreDataManager.swift
//  Notes
//
//  Created by Balamurugan on 14.07.21.
//  Copyright © 2021 . All rights reserved.
//

import Foundation
import CoreData

/// This class is responsible for creating and managing Core Data stack
final class CoreDataManager {
    static let shared: CoreDataManager = {
        CoreDataManager()
    }()

    // MARK: - Private Init

    private init() {}

    // MARK: - CoreData
    /// NSPersistentContainer simplifies the creation and management of the Core Data stack by handling the creation of the managed object model (NSManagedObjectModel),
    /// persistent store coordinator (NSPersistentStoreCoordinator),
    /// and the managed object context (NSManagedObjectContext).
    /// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/InitializingtheCoreDataStack.html
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }

            storeDescription.shouldMigrateStoreAutomatically = true
            storeDescription.shouldInferMappingModelAutomatically = true
        })

        return container
    }()

    /// Main background ManagedObjectContext. It is created in background queue,
    /// but used on main thread.
    /// A context consists of a group of related model objects that represent an internally consistent view of one or more persistent stores.
    /// Changes to managed objects remain in memory in the associated context until Core Data saves that context to one or more persistent stores.
    /// A single managed object instance exists in one and only one context,
    /// but multiple copies of an object can exist in different contexts.
    /// Therefore, an object is unique to a particular context.
    /// https://developer.apple.com/documentation/coredata/nsmanagedobjectcontext
    lazy var mainBackgroundContext: NSManagedObjectContext = {
        let managedObjectContext = persistentContainer.newBackgroundContext()
        managedObjectContext.mergePolicy = NSOverwriteMergePolicy

        return managedObjectContext
    }()

    /// Save changes, if there are changes in ManagedObjectContext
    /// - Parameter moc: NSManagedObjectContext
    /// - Throws: Error
    func saveContext (_ moc: NSManagedObjectContext) throws {
        guard moc.hasChanges else {
            return
        }

        return try moc.save()
    }
}
