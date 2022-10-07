//
//  IngredientServiceTests.swift
//  RecipleaseTests
//
//  Created by Yves Charpentier on 29/07/2022.
//

import XCTest
@testable import Reciplease

class IngredientServiceTests: XCTestCase {
    
    func testAddIngredient() {
        // Given
        let newIngredient = Ingredient(name: "Banana")
        // When
        try? IngredientService.shared.add(ingredient: newIngredient)
        // Then
        XCTAssertEqual(IngredientService.shared.ingredients.first?.name, "Banana")
    }
    
    func testIngredientIsAlreadyExist() {
        // Given
        let ingredient = Ingredient(name: "Banana")
        try? IngredientService.shared.add(ingredient: ingredient)
        
        // When
        
        // Then
        XCTAssertThrowsError(try IngredientService.shared.add(ingredient: ingredient))
    }
    
    func testRemoveIngredient() {
        // Given
        
        // When
        IngredientService.shared.remove(at: 0)
        // Then
        XCTAssertEqual(IngredientService.shared.ingredients.first?.name, nil)
    }
    
    func testClearAllIngredient() {
        // Given
        
        // When
        IngredientService.shared.clear()
        // Then
        XCTAssertEqual(IngredientService.shared.ingredients.first?.name, nil)
    }
}
