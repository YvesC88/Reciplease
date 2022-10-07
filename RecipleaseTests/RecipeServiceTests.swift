//
//  RecipeServiceTests.swift
//  RecipleaseTests
//
//  Created by Yves Charpentier on 26/07/2022.
//

import XCTest
import CoreData
@testable import Reciplease

class RecipeServiceTests: XCTestCase {
    
    // MARK: - Properties
    
    var sut = RecipeService()
    let networkService = NetworkServiceMock()
    var coreDataStackMock: CoreDataStackProtocol = CoreDataStackMock()
    
    override func setUp() {
        sut.networkService = networkService
        sut.coreDataStack = coreDataStackMock
    }
    
    // MARK: - Methods
    
    func testGetValueWithSuccess() {
        // Given
        networkService.isError = false
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        var savedResult: ResultRecipe?
        sut.getValue { result in
            savedResult = result
            expectation.fulfill()
        }
        // Then
        wait(for: [expectation], timeout: 0.01)
        XCTAssertNotNil(savedResult)
    }
    
    func testGetValueWithFailure() {
        // Given
        networkService.isError = true
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        var savedResult: ResultRecipe?
        
        sut.getValue { result in
            savedResult = result
            expectation.fulfill()
        }
        // Then
        wait(for: [expectation], timeout: 0.01)
        XCTAssertNil(savedResult)
    }
    
    func testGivenFakeRecipeWhenSaveFakeRecipeThenFakeRecipeIsSaved() {
        // Given
        
        //  When
        sut.saveRecipe(title: "Blackberry + Apple Cocktail",
                       subtitle: "",
                       with: nil,
                       ingredientLines: "",
                       like: 10,
                       time: 10,
                       uri: "",
                       url: "")
        
        // Then
        XCTAssertTrue((coreDataStackMock as! CoreDataStackMock).isSaveCalled)
    }
    
    func testGivenFakeRecipeWhenUnsaveFakeRecipeThenFakeRecipeIsUnsaved() {
        // Given
        sut.saveRecipe(title: "Blackberry + Apple Cocktail",
                       subtitle: "",
                       with: nil,
                       ingredientLines: "",
                       like: 10,
                       time: 10,
                       uri: "test",
                       url: "")
        // When
        sut.unsaveRecipe(uri: "test")
        // Then
        XCTAssertTrue((coreDataStackMock as! CoreDataStackMock).isUnsaveCalled)
    }
    
    func testRecipeIsFavorite() {
        // Given

        // When
        sut.saveRecipe(title: "Blackberry + Apple Cocktail",
                       subtitle: "",
                       with: nil,
                       ingredientLines: "",
                       like: 10,
                       time: 10,
                       uri: "https://www.apple.com",
                       url: "")
        // Then
        XCTAssertTrue(sut.isFavorite(recipeURI: "https://www.apple.com"))
    }
    
    func testRecipeIsNotFavorite() {
        // Given
        sut.saveRecipe(title: "Blackberry + Apple Cocktail",
                       subtitle: "",
                       with: nil,
                       ingredientLines: "",
                       like: 10,
                       time: 10,
                       uri: "https://www.apple.com",
                       url: "")
        // When

        // Then
        XCTAssertFalse(sut.isFavorite(recipeURI: "https://www.google.fr"))
    }
}
