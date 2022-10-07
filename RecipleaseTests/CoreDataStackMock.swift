//
//  CoreDataStackMock.swift
//  RecipleaseTests
//
//  Created by Yves Charpentier on 01/08/2022.
//

import Foundation
import CoreData
@testable import Reciplease

final class CoreDataStackMock: CoreDataStackProtocol {
    
    var isSaveCalled: Bool = false
    var isUnsaveCalled: Bool = false
    
    func save() throws {
        isSaveCalled = true
    }
    
    func unSave(uri: String) throws {
        isUnsaveCalled = true
    }
}
