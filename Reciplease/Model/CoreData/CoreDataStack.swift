//
//  CoreDataStack.swift
//  Reciplease
//
//  Created by Yves Charpentier on 28/06/2022.
//

import Foundation
import CoreData

protocol CoreDataStackProtocol {
    func save() throws
    func unSave(uri: String) throws
}

open class CoreDataStack: CoreDataStackProtocol {
    
    // MARK: - Properties
    
    let persistentContainerName = "Reciplease"
    
    static let share = CoreDataStack()
    
    var viewContext: NSManagedObjectContext {
        return CoreDataStack.share.persistentContainer.viewContext
    }
    
    init() {}
    
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: persistentContainerName)
        container.loadPersistentStores(completionHandler: { storeDescritpion, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo) for : \(storeDescritpion.description)")
            }
        })
        return container
    }()
    
    
    // MARK: - Methods
    
    func save() throws {
        do {
            try viewContext.save()
        } catch {
            print("Error")
        }
    }

    func unSave(uri: String) throws {
        let fetchRequest: NSFetchRequest<LocalRecipe>
        fetchRequest = LocalRecipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uri == %@", uri)
        let result = try? viewContext.fetch(fetchRequest)
        if let localRecipe = result?.first {
            viewContext.delete(localRecipe)
            do {
                try viewContext.save()
            } catch {
                print("Error")
            }
        }
    }
}
