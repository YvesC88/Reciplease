//
//  CoreDataStack.swift
//  Reciplease
//
//  Created by Yves Charpentier on 28/06/2022.
//

import Foundation
import CoreData

final class CoreDataStack {
    
    private let persistentContainerName = "Reciplease"
    
    static let share = CoreDataStack()
    
    var viewContext: NSManagedObjectContext {
        return CoreDataStack.share.peristentContainer.viewContext
    }
    
    private lazy var peristentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: persistentContainerName)
        container.loadPersistentStores(completionHandler: { storeDescritpion, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo) for : \(storeDescritpion.description)")
            }
        })
        return container
    }()
}
