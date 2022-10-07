//
//  CoreDataStackTest.swift
//  RecipleaseTests
//
//  Created by Yves Charpentier on 04/10/2022.
//

import XCTest
import CoreData
@testable import Reciplease

final class CoreDataStackTest: XCTestCase {
    
    // MARK: - Properties
    
    var sut = CoreDataStack()
    
    // MARK: - Methods

    func testGivenFakeRecipeWhenSaveRecipeThenRecipeIsSaved() {
        // Given
        let fakeRecipe = LocalRecipe(context: sut.viewContext)
        fakeRecipe.title = "TestSave"
        fakeRecipe.uri = "https://www.google.fr"
        
        // When
        XCTAssertNoThrow(try sut.save())

        // Then
        let fetchRequest: NSFetchRequest<LocalRecipe>
        fetchRequest = LocalRecipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", "TestSave")
        let result = try? sut.viewContext.fetch(fetchRequest)

        XCTAssertEqual(result?.count, 1)
        XCTAssertNoThrow(try sut.unSave(uri: fakeRecipe.uri!))
    }
    
    func testGivenFakeRecipeWhenUnsaveRecipeThenRecipeIsUnsaved() {
        // Given
        let fakeRecipe = LocalRecipe(context: sut.viewContext)
        fakeRecipe.title = "TestUnsave"
        fakeRecipe.uri = "https://www.google.fr"
        
        // When
        XCTAssertNoThrow(try sut.unSave(uri: fakeRecipe.uri!))
        
        // Then
        XCTAssertEqual(fakeRecipe.title, nil)
        XCTAssertEqual(fakeRecipe.uri, nil)
    }
}
